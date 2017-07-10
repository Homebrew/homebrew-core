require "language/node"

class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag => "v5.5.0",
      :revision => "e1950ab7d0686b3a01caa0899faf4bf5a5e4904c"
  head "https://github.com/elastic/kibana.git"

  bottle do
    sha256 "004cbb037aa28a153fc03350db4409232e1e4bdc2c84b1eb17d0280713881ad4" => :sierra
    sha256 "e58ca66b61ce1908e4a7bb28552ff1790d1129a98c86224ca7f5bed13904cb8a" => :el_capitan
    sha256 "3181532590e7b2dce1e4043dfc9b845e618b4eb8f0241a13d2101fe0fd4854ea" => :yosemite
  end

  resource "node" do
    url "https://nodejs.org/dist/v6.10.2/node-v6.10.2.tar.xz"
    sha256 "80aa11333da99813973a99646e2113c6be5b63f665c0731ed14ecb94cbe846b6"
  end

  def install
    resource("node").stage do
      system "./configure", "--prefix=#{libexec}/node"
      system "make", "test"
      system "make", "install"
    end

    # do not build packages for other platforms
    platforms = Set.new(["darwin-x64", "linux-x64", "windows-x64"])
    if MacOS.prefer_64_bit?
      platform = "darwin-x64"
    else
      raise "Installing Kibana via Homebrew is only supported on macOS x86_64"
    end
    platforms.delete(platform)
    sub = platforms.to_a.join("|")
    inreplace buildpath/"tasks/config/platforms.js", /('(#{sub})',?(?!;))/, "// \\1"

    # trick the build into thinking we've already downloaded the Node.js binary
    mkdir_p buildpath/".node_binaries/#{resource("node").version}/#{platform}"

    # set npm env and fix cache edge case (https://github.com/Homebrew/brew/pull/37#issuecomment-208840366)
    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    system "npm", "install", "-ddd", "--build-from-source", "--#{Language::Node.npm_cache_config}"
    system "npm", "run", "build", "--", "--release", "--skip-os-packages", "--skip-archives"

    prefix.install Dir["build/kibana-#{version}-#{platform.sub("x64", "x86_64")}/{bin,config,node_modules,optimize,package.json,src,ui_framework,webpackShims}"]

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

  def caveats; <<-EOS.undent
    Config: #{etc}/kibana/
    If you wish to preserve your plugins upon upgrade, make a copy of
    #{opt_prefix}/plugins before upgrading, and copy it into the
    new keg location after upgrading.
    EOS
  end

  plist_options :manual => "kibana"

  def plist; <<-EOS.undent
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
