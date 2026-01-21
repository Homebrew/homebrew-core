class Gravitino < Formula
  desc "High-performance, geo-distributed, and federated metadata lake"
  homepage "https://gravitino.apache.org"
  url "https://github.com/apache/gravitino/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "5b7da20629850440bfe221452d777815a429b68afc624cd49ac1b7aa70a8ebd6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63902e35657d833c4a83fbed47492a2c3966ac4d1bf0e5601072f4865562a060"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2a3bc0059143c009c4e9a603cc2bba88044a8b904f33ec74b6f4c18758ef38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ca78e5790d1242b837dee99699aecbcc241701555f61dfaf64196bbcd3023a"
    sha256 cellar: :any_skip_relocation, sonoma:        "02a4dc8f6817eeee0cb4c058af06212566e4c0ee15f49046eeb69cb663e4e5ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a1cf98112722089214cb985af489791a75c61a91f8aa4bac32e4a7023e17e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a87b9c06823465aedc68dac0d7ba0399a9ee140ba317f3716638dcb3f230c7"
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
