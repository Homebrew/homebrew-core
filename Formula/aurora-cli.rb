class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.17.0/apache-aurora-0.17.0.tar.gz"
  sha256 "2a7477d7275dd20f86fe5b0c2d7e884a4c8251dca055045c575cd365799ca548"

  bottle do
    cellar :any_skip_relocation
    sha256 "96f4818d2b60d039b5b329de3a0c535abe9d357cf2568ce5e6a03331f381831f" => :sierra
    sha256 "a040d213930834e440fee818c7608aa915cb95781cf33426355ac929c92947f5" => :el_capitan
    sha256 "f81dbf4693ca54388d6c1e1d21baab81c128240d7b82e97e9669641112c27fda" => :yosemite
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
