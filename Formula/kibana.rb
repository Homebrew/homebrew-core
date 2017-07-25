require "language/node"

class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag => "v5.5.1",
      :revision => "32ff80dbccdff23911015425bfaf4ae32ea0c0c1"
  head "https://github.com/elastic/kibana.git"

  bottle do
    sha256 "c27b83a19870dec9a9fddb0fa9298a067adc49aa465b87900072d9a2a8207baa" => :sierra
    sha256 "53d004692f0c43b25d92cd848c697c374da55be09ef053d4567d56be9bd73b84" => :el_capitan
    sha256 "63a4e1d4c60d97aa20f6759d0fbd90a81fced80b984040bc389adb9e12caaade" => :yosemite
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
