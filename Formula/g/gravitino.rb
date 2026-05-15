class Gravitino < Formula
  desc "High-performance, geo-distributed, and federated metadata lake"
  homepage "https://gravitino.apache.org"
  url "https://github.com/apache/gravitino/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "f0c788245f0d6ce0f31ecf53eae8af64add8e601c105cc65fc6eb34591cea3cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "112c25e374e904df246e33eb0a0ff5d65195d466fbc77f81ffdd93d529061346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44767d2c12dcb60aa477eb6f4a2b2e02b3620fb83eff1988d99d6027a70f85f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5de05de794c047666e48b450b7ce61c7cdb1473f962866a74f39a8e9a0fc377"
    sha256 cellar: :any_skip_relocation, sonoma:        "359d11ee0a917fbebffa1454104ccb3bc4e1e41eb1fff79ef5fc3ca945ff3efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17497e31968f86cd28620b035727b4960bdf9f137255d09f04017e55b1a901e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1188ad8f1efc7dc453bf6f75f65044c77d8f77bce38745d33f417e7e40c183"
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
