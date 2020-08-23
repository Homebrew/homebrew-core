class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      tag:      "v7.8.1",
      revision: "5db9c677ea993ff3df503df03d03f5657fcea42e"
  license "Apache-2.0"
  head "https://github.com/elastic/kibana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2d25d2bf89cf7adee42ff1cf4977a906db3d9d07b8d23dcbc2c9c660a6a3d0a" => :catalina
    sha256 "27f62cf43515c96242609d8eea66550d9d8ea79b1de903381262e3673ae609be" => :mojave
    sha256 "1922f3a6c69e1d3157673884428fe8116e3567a7dac5119e37d8c6a1427f41e3" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "yarn" => :build
  depends_on "node@10"

  def install
    # remove non open source files
    rm_rf "x-pack"

    inreplace "package.json", /"node": "10\.\d+\.\d+"/, %Q("node": "#{Formula["node@10"].version}")
    system "yarn", "kbn", "bootstrap"
    system "node", "scripts/build", "--oss", "--release", "--skip-os-packages", "--skip-archives"

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
