class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.17.0/apache-aurora-0.17.0.tar.gz"
  sha256 "2a7477d7275dd20f86fe5b0c2d7e884a4c8251dca055045c575cd365799ca548"

  bottle do
    cellar :any_skip_relocation
    sha256 "a06288f99cada7e310455d243a99780151d7bb484ee230d769577279f2db06fb" => :sierra
    sha256 "e11368a651d7823e8c5a399ed98b970fcbb788d7e9cbb1f5359ed96c39c42508" => :el_capitan
    sha256 "fe5c388a7d9cfe8a22a84301ee6fb2819e99d9bf364d768f7373d2d1030324a0" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "./pants", "binary", "src/main/python/apache/aurora/kerberos:kaurora"
    system "./pants", "binary", "src/main/python/apache/aurora/kerberos:kaurora_admin"
    bin.install "dist/kaurora.pex" => "aurora"
    bin.install "dist/kaurora_admin.pex" => "aurora_admin"
  end

  test do
    ENV["AURORA_CONFIG_ROOT"] = "#{testpath}/"
    (testpath/"clusters.json").write <<-EOS.undent
        [{
          "name": "devcluster",
          "slave_root": "/tmp/mesos/",
          "zk": "172.16.64.185",
          "scheduler_zk_path": "/aurora/scheduler",
          "auth_mechanism": "UNAUTHENTICATED"
        }]
    EOS
    system "#{bin}/aurora_admin", "get_cluster_config", "devcluster"
  end
end
