class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/3.6.1/cassandra-reaper-3.6.1-release.tar.gz"
  sha256 "8e5004692d031e2abe47c26c066d853fb1f841b23833edd66d58ff54bef82399"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7984dbd6e5685cd5982654f0185127995ad58864a11967625d8d23ab5b123bb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7984dbd6e5685cd5982654f0185127995ad58864a11967625d8d23ab5b123bb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7984dbd6e5685cd5982654f0185127995ad58864a11967625d8d23ab5b123bb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7984dbd6e5685cd5982654f0185127995ad58864a11967625d8d23ab5b123bb1"
    sha256 cellar: :any_skip_relocation, ventura:        "7984dbd6e5685cd5982654f0185127995ad58864a11967625d8d23ab5b123bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "7984dbd6e5685cd5982654f0185127995ad58864a11967625d8d23ab5b123bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460f8d174ebdf7a2fda217d968801180d523ca7b9953938fad1cf461487fe295"
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
      s.gsub! "storageType: memory", "storageType: memory\npersistenceStoragePath: #{testpath}/persistence"
    end

    fork do
      exec bin/"cassandra-reaper", testpath/"cassandra-reaper.yaml"
    end
    sleep 40
    assert_match "200 OK", shell_output("curl -Im3 -o- http://localhost:#{port}/webui/login.html")
  end
end
