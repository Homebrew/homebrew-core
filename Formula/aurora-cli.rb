class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.21.0/apache-aurora-0.21.0.tar.gz"
  sha256 "4b608e5199ae72c83b0bc97569de5ed2c58d73a709f6906c3664154144438b65"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bdec41534eb705691db0fd301dc2e76349ba458971c5d699a3dc8b6ec12f494" => :mojave
    sha256 "8e8b1b203a68dd13016f16ce393819ee0cbaaa4e46c923e17c3774bfaf32656e" => :high_sierra
    sha256 "3e5af36a5af5ab82b48efeed7134cab6736719994831e49a760f63ed6ae1b7fe" => :sierra
    sha256 "0aa81ba9c237f213417b5c3c60409d2f754953a98ff3f6eb5c41ec991b90f2d0" => :el_capitan
  end

  depends_on "python@2"

  def install
    # No pants yet for Mojave, so we force High Sierra binaries there
    ENV["PANTS_BINARIES_PATH_BY_ID"] = "{('darwin','15'):('mac','10.11'),('darwin','16'):('mac','10.12'),('darwin','17'):('mac','10.13'),('darwin','18'):('mac','10.13')}"

    system "./pants", "binary", "src/main/python/apache/aurora/kerberos:kaurora"
    system "./pants", "binary", "src/main/python/apache/aurora/kerberos:kaurora_admin"
    bin.install "dist/kaurora.pex" => "aurora"
    bin.install "dist/kaurora_admin.pex" => "aurora_admin"
  end

  test do
    ENV["AURORA_CONFIG_ROOT"] = "#{testpath}/"
    (testpath/"clusters.json").write <<~EOS
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
