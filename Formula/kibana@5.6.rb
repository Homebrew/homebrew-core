require "language/node"

class KibanaAT56 < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag      => "v5.6.14",
      :revision => "f909937e01a4b1a9e6b3d48d281fd3fe6a819510"

  bottle do
    sha256 "18deeaa1b8dad4a91b2ad3ab7986ec69fbf9328e57409a10986f93b00db50d63" => :mojave
    sha256 "bcaa16ba671d40a45051bef8ffd56b07ae3e5643e6bd1be4a423ab535ae604a6" => :high_sierra
    sha256 "9497dba02685d1d4cc88c7aed2b79cc6a10cddfc24d76fd2c8d6722f2e44f189" => :sierra
  end

  keg_only :versioned_formula

  resource "node" do
    url "https://nodejs.org/dist/v6.15.1/node-v6.15.1.tar.xz"
    sha256 "c3bde58a904b5000a88fbad3de630d432693bc6d9d6fec60a5a19e68498129c2"
  end

  def install
    resource("node").stage do
      system "./configure", "--prefix=#{libexec}/node"
      system "make", "install"
    end

    # remove with next release: revert incorrect package.json version number
    inreplace buildpath/"package.json", "\"version\": \"5.6.15\",", "\"version\": \"5.6.14\","

    # do not build packages for other platforms
    inreplace buildpath/"tasks/config/platforms.js", /('(linux-x64|windows-x64)',?(?!;))/, "// \\1"

    # trick the build into thinking we've already downloaded the Node.js binary
    mkdir_p buildpath/".node_binaries/#{resource("node").version}/darwin-x64"

    # set MACOSX_DEPLOYMENT_TARGET to compile native addons against libc++
    inreplace libexec/"node/include/node/common.gypi", "'MACOSX_DEPLOYMENT_TARGET': '10.7',",
                                                       "'MACOSX_DEPLOYMENT_TARGET': '#{MacOS.version}',"
    ENV["npm_config_nodedir"] = libexec/"node"

    # set npm env and fix cache edge case (https://github.com/Homebrew/brew/pull/37#issuecomment-208840366)
    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    system "npm", "install", "-ddd", "--build-from-source", "--#{Language::Node.npm_cache_config}"
    system "npm", "run", "build", "--", "--release", "--skip-os-packages", "--skip-archives"

    prefix.install Dir["build/kibana-#{version}-darwin-x86_64/{bin,config,node_modules,optimize,package.json,src,ui_framework,webpackShims}"]

    inreplace "#{bin}/kibana", %r{/node/bin/node}, "/libexec/node/bin/node"
    inreplace "#{bin}/kibana-plugin", %r{/node/bin/node}, "/libexec/node/bin/node"

    cd prefix do
      inreplace "config/kibana.yml", "/var/run/kibana.pid", var/"run/kibana.pid"
      (etc/"kibana").install Dir["config/*"]
      rm_rf "config"
    end
  end

  def post_install
    ln_s etc/"kibana", prefix/"config"
    (prefix/"data").mkdir
    (prefix/"plugins").mkdir
  end

  def caveats; <<~EOS
    Config: #{etc}/kibana/
    If you wish to preserve your plugins upon upgrade, make a copy of
    #{opt_prefix}/plugins before upgrading, and copy it into the
    new keg location after upgrading.
  EOS
  end

  plist_options :manual => "kibana"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/kibana</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"
    assert_match /#{version}/, shell_output("#{bin}/kibana -V")
  end
end
