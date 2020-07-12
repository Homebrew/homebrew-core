class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag      => "v7.8.0",
      :revision => "1244c9fa76dccc0c8123a47aca33bddb66e298af"
  license "Apache-2.0"
  head "https://github.com/elastic/kibana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5ce7fd2c2cb57b276d3fd61609712e5b4171ae65e45ad8f4ba114912c9513d0" => :catalina
    sha256 "50a13ed2c843f98cea0f0a7067236c33295021074ffec07099912f675ec36625" => :mojave
    sha256 "93c8a343c2122142b977c64c9c178f2c96bb1b8fdc03446f71a0961387f928e5" => :high_sierra
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

  plist_options :manual => "kibana"

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
