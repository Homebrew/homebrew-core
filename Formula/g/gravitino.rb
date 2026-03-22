class Gravitino < Formula
  desc "High-performance, geo-distributed, and federated metadata lake"
  homepage "https://gravitino.apache.org"
  url "https://github.com/apache/gravitino/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "be6d91e82238b0e0f278da15aefc50f0aca6629cd8da9bdc166d480da37e7587"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "641a82af33b7429303564b2f84eb386ac4a2d9f5d01c25d1fdd63e0d07013fa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6622a82fa02859a0aad59ccb8b8e900b24c6d405d0666362c8e0464276766d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd2a6c8e484b198c8296cbbb57343484ba1c0880af8675e4fcd8aa05313b7c82"
    sha256 cellar: :any_skip_relocation, sonoma:        "2362b8120e8a3a5bbd5bf7e02d0d4183fb679410a8fca44599e2f56cde0c54b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af63c907575edeb2f12fe71afcd49fdf53a2dc4f22a3725736c868f579f3853d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8bd081555348ab2c099a7628ca44d69940988c57407d56aafde1ad80012b57"
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
