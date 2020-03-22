require "language/node"

class KibanaAT56 < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag      => "v5.6.16",
      :revision => "e4c8b3e8245cbf4f81d0d31476c61125e366c2d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "74a4ff8c4b94acf7b9e6b07a7eb597c922d29bbaa11d92e36e38ab243070afa7" => :catalina
    sha256 "5718b742a4505d7b5844dac7ae74c8909830a8acf92b9904d26efa177de63a52" => :mojave
    sha256 "f6f111399387e6d22169f8a9f527fc12c709cd86f2282b919a54433b5a8461c6" => :high_sierra
    sha256 "0d7822349fe000d31c07d04eb19eb7d2f2038fd1e63f46dcdd6d4ea45a0453c4" => :sierra
  end

  keg_only :versioned_formula

  resource "node" do
    url "https://nodejs.org/dist/v6.17.0/node-v6.17.0.tar.xz"
    sha256 "c1dac78ea71c2e622cea6f94ba97a4be49329a1d36cd05945a1baf1ae8652748"
  end

  def install
    resource("node").stage do
      system "./configure", "--prefix=#{libexec}/node"
      system "make", "install"
    end

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

    prefix.install Dir["build/kibana-#{version}-darwin-x86_64/"\
                       "{bin,config,node_modules,optimize,package.json,src,ui_framework,webpackShims}"]

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

  def caveats
    <<~EOS
      Config: #{etc}/kibana/
      If you wish to preserve your plugins upon upgrade, make a copy of
      #{opt_prefix}/plugins before upgrading, and copy it into the
      new keg location after upgrading.
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/kibana@5.6/bin/kibana"

  def plist
    <<~EOS
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
