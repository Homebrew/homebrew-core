class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag => "v6.4.1",
      :revision => "2872c74872c54d91e3e00b67c7bbc61659df0ba7"
  head "https://github.com/elastic/kibana.git"

  bottle do
    sha256 "990d72d9eb8572e62424519be38041c48c24e3e3206b8f1e58f72449c3c34906" => :high_sierra
    sha256 "de9ecf592509e75446c5298a8423982ed9e9d705691818233242f6a35519a50c" => :sierra
    sha256 "057d166935aa00f6564b4ca6ee4eb237b3c7f08a3d9d9bf351f3c08f5d08bff7" => :el_capitan
  end

  resource "node" do
    url "https://nodejs.org/dist/v8.11.4/node-v8.11.4.tar.xz"
    sha256 "fbce7de6d96b0bcb0db0bf77f0e6ea999b6755e6930568aedaab06847552a609"
  end

  resource "yarn" do
    url "https://yarnpkg.com/downloads/1.9.4/yarn-v1.9.4.tar.gz"
    sha256 "7667eb715077b4bad8e2a832e7084e0e6f1ba54d7280dc573c8f7031a7fb093e"
  end

  def install
    resource("node").stage do
      system "./configure", "--prefix=#{libexec}/node"
      system "make", "install"
    end

    # remove non open source files
    rm_rf "x-pack"

    # trick the build into thinking we've already downloaded the Node.js binary
    mkdir_p buildpath/".node_binaries/#{resource("node").version}/darwin-x64"

    # run yarn against the bundled node version and not our node formula
    (buildpath/"yarn").install resource("yarn")
    (buildpath/".brew_home/.yarnrc").write "build-from-source true\n"
    ENV.prepend_path "PATH", buildpath/"yarn/bin"
    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    system "yarn", "kbn", "bootstrap"
    system "yarn", "build", "--oss", "--release", "--skip-os-packages", "--skip-archives"

    prefix.install Dir["build/oss/kibana-#{version}-darwin-x86_64/{bin,config,node_modules,optimize,package.json,src,ui_framework,webpackShims}"]
    mv "licenses/APACHE-LICENSE-2.0.txt", "LICENSE.txt" # install OSS license

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
