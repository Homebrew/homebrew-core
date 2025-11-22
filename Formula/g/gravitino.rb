class Gravitino < Formula
  desc "High-performance, geo-distributed, and federated metadata lake"
  homepage "https://gravitino.apache.org"
  url "https://github.com/apache/gravitino/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c2da3c856d67fa012f61589ecd7095ebd3a43580a9908cb6a1f34ccf99a309ff"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "135a16d211295375cde56d21c337345292d5ca509f7794285e9b3f725878040b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27b58d0bb01f267c4d591f4448139aeaa03d83e2c54655061613171124bcee67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c745998dcdb5831c1869e80978bebaf7c48a333608815d3c2f5b986ca965c4b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "df7e049c379aa142cd3768c21aeb6dcced4f8c48feb04502e6a28e9d71ade7b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e1f01174f9464f6f1b12323c737a3b8bdd69bb724fcfb28c5bb995ed1e10396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1309f446819ecfe814171730dcc0c4259f3d5c9014d39b03369b4976c09abd7"
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
