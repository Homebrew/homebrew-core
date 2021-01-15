class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      tag:      "v7.10.2",
      revision: "a0b793698735eb1d0ab1038f8e5d7a951524e929"
  license "Apache-2.0"
  head "https://github.com/elastic/kibana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fee3e848d8b9c2889b7fa89b7a6cdfbfa85b2dbf23712a5b07b58d676f60f73c" => :big_sur
    sha256 "5d8234a00c1b04278c083dd3deede12eb622c887e3338fc6e5906651dbb216a0" => :catalina
    sha256 "454a4b3df30516055103c0bbd0783705d26d92659352ec2e3d37a2c0bb6326d2" => :mojave
  end

  depends_on "python@3.9" => :build
  depends_on "yarn" => :build
  depends_on "node@10"

  def install
    inreplace "package.json", /"node": "10\.\d+\.\d+"/, %Q("node": "#{Formula["node@10"].version}")

    # prepare project after checkout
    system "yarn", "kbn", "bootstrap"

    # build open source only
    system "node", "scripts/build", "--oss", "--release", "--skip-os-packages", "--skip-archives"

    # remove non open source files
    rm_rf "x-pack"

    prefix.install Dir
      .glob("build/oss/kibana-#{version}-darwin-x86_64/**")
      .reject { |f| File.fnmatch("build/oss/kibana-#{version}-darwin-x86_64/{node, data, plugins}", f) }
    mv "licenses/APACHE-LICENSE-2.0.txt", "LICENSE.txt" # install OSS license

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

  plist_options manual: "kibana"

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

    (testpath/"data").mkdir
    (testpath/"config.yml").write <<~EOS
      path.data: #{testpath}/data
    EOS

    port = free_port
    fork do
      exec bin/"kibana", "-p", port.to_s, "-c", testpath/"config.yml"
    end
    sleep 15
    output = shell_output("curl -s 127.0.0.1:#{port}")
    # Kibana returns this message until it connects to Elasticsearch
    assert_equal "Kibana server is not ready yet", output
  end
end
