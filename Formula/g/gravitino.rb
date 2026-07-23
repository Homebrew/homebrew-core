class Gravitino < Formula
  desc "High-performance, geo-distributed, and federated metadata lake"
  homepage "https://gravitino.apache.org"
  url "https://github.com/apache/gravitino/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "26fcd207e7728b68e46ba2cadfc3de4fee632795e55e8ab28049ecde5a718af5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "794b4cc79e434926e460b0d0697ae2e5198efec4fdd6fd9ef73c32c55d8d872c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4901ff795ebf93c216a95118c47f3f4981aeac8cda7c50411b4f0adc5d9ea1c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf599f7ae3b3366ca3a912d1e38173295ed63a2fa8eec6469542715b4deb31b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ef093c496da92d131e1fadc8f14bf2a2c6fb54ba9ba7568634f14135d1cae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "401f2545ca7c3e9a6b0bcf6e4cb1ad45be626cf8e2860443a4f76320d79b3781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7394f88858b425fc22774a867ce23a19e24eb9ad8cceb3a908f851a0b4d5fe14"
  end

  depends_on "gradle@8" => :build # Gradle 9 issue ref: https://github.com/apache/gravitino/issues/8571
  depends_on "node" => :build
  depends_on "openjdk@17" # OpenJDK 21 issue ref: https://github.com/apache/gravitino/issues/7976

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
