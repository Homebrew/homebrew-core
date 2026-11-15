class Gravitino < Formula
  desc "High-performance, geo-distributed, and federated metadata lake"
  homepage "https://gravitino.apache.org"
  url "https://github.com/apache/gravitino/releases/download/v1.3.1/gravitino-1.3.1-src.tar.gz"
  sha256 "d9f4abda3d8397cc38cc116c86c796fc634eb15c040dcafa286b3c02455331a2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99b10dc44d27ead919f150edc4f52ccb3cec1178dae11ca304a4f13f9c666a3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "260ee6421d3606256a110a9b99ad1a362a58bdfc60680da6e721ea77d7141da6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1a76015c8a30240478cc6164bae73c595a371614ea4379beaf1bae886943408"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f578548ff65f5be79e684d3a6e253d0a8b97c4200085660cff0fa8c968e631a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0976b1cd1ae095dffc1fe12e66764554bed144efc3591f7d5b75e11819911a13"
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
