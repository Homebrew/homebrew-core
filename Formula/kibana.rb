class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  # NOTE: Do not bump version to one with a non-open-source license
  url "https://github.com/elastic/kibana.git",
      tag:      "v7.10.2",
      revision: "a0b793698735eb1d0ab1038f8e5d7a951524e929"
  license "Apache-2.0"
  head "https://github.com/elastic/kibana.git"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "3ada496bcdff84e29654d2bf0f35195cc6df7f3686b7a51b49c77138930958cf"
    sha256 cellar: :any_skip_relocation, big_sur:  "c218ab10fca2ebdddd11ab27326d0a6d0530a7f26bc2adc26d1751e4326b0198"
    sha256 cellar: :any_skip_relocation, catalina: "c1ee01e41c34677dba144152142808d469db2855658fdd3e4fcafbae77a10774"
    sha256 cellar: :any_skip_relocation, mojave:   "fb818924d852b07ab0417e8ff52899400b98f25bd24714f77a8c472224269690"
  end

  # elasticsearch will be relicensed before v7.11.
  # https://www.elastic.co/blog/licensing-change
  deprecate! date: "2021-01-14", because: "is switching to an incompatible license"

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
