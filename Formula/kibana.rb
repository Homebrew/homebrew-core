require "language/node"

class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag => "v5.5.2",
      :revision => "3352f60107f55921ad4761fa1f77d67a0315e6ad"
  head "https://github.com/elastic/kibana.git"

  bottle do
    sha256 "fd335001c00c1d0848acbe1f827a0bd03fc34a572bbb73f6275f9e12bfb523ea" => :sierra
    sha256 "ea13fe112907b5aec74421e3d37087857ddf298c774a4e96fe5d72337b787f32" => :el_capitan
    sha256 "938cd703e60029c11963413f6b539a22fb636c5f2f21a5c88a345761bd99b92b" => :yosemite
  end

  resource "node" do
    url "https://nodejs.org/dist/v6.11.1/node-v6.11.1.tar.xz"
    sha256 "6f6655b85919aa54cb045a6d69a226849802fcc26491d0db4ce59873e41cc2b8"
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
