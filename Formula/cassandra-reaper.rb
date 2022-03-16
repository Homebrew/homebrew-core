class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/3.1.1/cassandra-reaper-3.1.1-release.tar.gz"
  sha256 "8d71f6e74306f4ef33cc1af6822d7a3702f347355589d66cd899ce546df12d1e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "ff2caf27f8ba961fff6b24980c4fb9b8d7d19b28bc7b13a71a60999e0e1ee3db"
    sha256 cellar: :any_skip_relocation, big_sur:      "ff2caf27f8ba961fff6b24980c4fb9b8d7d19b28bc7b13a71a60999e0e1ee3db"
    sha256 cellar: :any_skip_relocation, catalina:     "ff2caf27f8ba961fff6b24980c4fb9b8d7d19b28bc7b13a71a60999e0e1ee3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5ef86195c0f8f1b9ef8620e9d4abdf3cfaee2b5b6a68503252bb78d8f0375b6c"
  end

  depends_on "openjdk@11"

  def install
    inreplace Dir["resource/*.yaml"], " /var/log", " #{var}/log"
    inreplace "bin/cassandra-reaper", "/usr/local/share", share
    inreplace "bin/cassandra-reaper", "/usr/local/etc", etc

    libexec.install "bin/cassandra-reaper"
    prefix.install "bin"
    etc.install "resource" => "cassandra-reaper"
    share.install "server/target" => "cassandra-reaper"

    (bin/"cassandra-reaper").write_env_script libexec/"cassandra-reaper",
      Language::Java.overridable_java_home_env("11")
  end

  service do
    run opt_bin/"cassandra-reaper"
    keep_alive true
    error_log_path var/"log/cassandra-reaper/service.err"
    log_path var/"log/cassandra-reaper/service.log"
  end

  test do
    cp etc/"cassandra-reaper/cassandra-reaper.yaml", testpath
    port = free_port
    inreplace "cassandra-reaper.yaml" do |s|
      s.gsub! "port: 8080", "port: #{port}"
      s.gsub! "port: 8081", "port: #{free_port}"
    end
    fork do
      exec "#{bin}/cassandra-reaper", "#{testpath}/cassandra-reaper.yaml"
    end
    sleep 30
    assert_match "200 OK", shell_output("curl -Im3 -o- http://localhost:#{port}/webui/login.html")
  end
end
