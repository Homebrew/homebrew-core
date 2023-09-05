class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/3.3.3/cassandra-reaper-3.3.3-release.tar.gz"
  sha256 "001293154fa81f2d360f0c4dfcf71ce71500433a3279e77450c407b4677597be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ca65d24a4519c6542176b0e2b2f994cc74dfc779ea4886ed40ae1cfcd2e629a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca65d24a4519c6542176b0e2b2f994cc74dfc779ea4886ed40ae1cfcd2e629a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ca65d24a4519c6542176b0e2b2f994cc74dfc779ea4886ed40ae1cfcd2e629a"
    sha256 cellar: :any_skip_relocation, ventura:        "3ca65d24a4519c6542176b0e2b2f994cc74dfc779ea4886ed40ae1cfcd2e629a"
    sha256 cellar: :any_skip_relocation, monterey:       "3ca65d24a4519c6542176b0e2b2f994cc74dfc779ea4886ed40ae1cfcd2e629a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ca65d24a4519c6542176b0e2b2f994cc74dfc779ea4886ed40ae1cfcd2e629a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48efe146d440177527b7b2ae8649a2a6c146bfb724702477449b672af851eb39"
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
