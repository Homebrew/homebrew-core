class Gravitino < Formula
  desc "High-performance, geo-distributed, and federated metadata lake"
  homepage "https://gravitino.apache.org"
  url "https://github.com/apache/gravitino/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cf29b125fe94e1af419386c9ba139e096aae56c176a1376c82c91449e7df9e30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "278250347c3765bdf1f146bceee97a62497e3bbff81e73081c24824010303d9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a206a27a30b16f1f407c8ad555c5a5348a03dc1b37681007ee42d181e8ab4539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d215cdd76606769c515affedaa6f8573267ad163dd746515151d51bf31e5d4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b490be04cf0fb910155d20d6aaf1ead9eaafae791fb172988d3e4ea38e4216"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "163f63b146832a8446daf06075aeac012721289be1217bc7d9c643786bd9e782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10819b572a83d0bdfab61bcf2627aaecae9326900d76b30e25acf56df67905f1"
  end

  # Issue ref: https://github.com/apache/gravitino/issues/8571
  depends_on "gradle@8" => :build
  depends_on "node" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "gradle", "compileDistribution", "-x", "test"

    (buildpath/"distribution/package/conf/gravitino.conf").write <<~CONF, mode: "a+"
      gravitino.entity.store.relational.storagePath = #{var}/gravitino
    CONF
    pkgetc.install buildpath.glob("distribution/package/conf/*")
    libexec.install buildpath.glob("distribution/package/*")

    %w[gravitino.sh gravitino-iceberg-rest-server.sh].each do |script|
      (bin/script).write_env_script libexec/"bin/#{script}", Language::Java.overridable_java_home_env("17")
    end
  end

  service do
    run [opt_bin/"gravitino.sh", "--config", etc/"gravitino", "run"]
    keep_alive true
    error_log_path var/"log/gravitino.log"
    log_path var/"log/gravitino.log"
  end

  test do
    port = free_port
    cp_r etc/"gravitino/.", testpath
    inreplace "gravitino.conf" do |s|
      s.sub! "httpPort = 8090", "httpPort = #{port}"
      s.sub! "httpPort = 9001", "httpPort = #{free_port}"
      s.sub! "#{var}/gravitino", testpath.to_s
    end
    ENV["GRAVITINO_LOG_DIR"] = testpath

    begin
      system bin/"gravitino.sh", "--config", testpath, "start"
      sleep 5
      output = shell_output("curl -s http://localhost:#{port}/api/metalakes")
      assert_match "metalakes", output
    ensure
      system bin/"gravitino.sh", "--config", testpath, "stop"
    end
  end
end
