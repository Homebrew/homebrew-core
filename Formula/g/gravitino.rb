class Gravitino < Formula
  desc "High-performance, geo-distributed, and federated metadata lake"
  homepage "https://gravitino.apache.org"
  url "https://github.com/apache/gravitino/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "fa141ce3bfc68630d208b32a24de65e8639bfc1774133494837452ffa879031a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c948147618da262c7b6cd75528fa407268a8a54c392f4ba2707ef91d228b6fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f74f55cad208bb19e1aca2c86477a5bf2d9e6f26befaabbadc05435fef4d1523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df67562b97e3b4137c67416ff781a9846b57c65f2cfc250477ec3b2cb9891fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d873054da69be3d3a9595d737708f7282fd9b0df6f59b7c2e4b6b6979f66a2a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9d53038e47aa88deadb696e19e1b9cab19996537261160982a5eae01d3fb9b7"
    sha256 cellar: :any_skip_relocation, ventura:       "976e7814856f21c4d1e2b8cdf7f8c53381ca0a28e576b07ed1ef4cf3144d4297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9432a842a266f9eb8e8277aa74863319499de21726ab1a57b8ed7457d7613c03"
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
