class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=aurora/0.22.0/apache-aurora-0.22.0.tar.gz"
  mirror "https://archive.apache.org/dist/aurora/0.22.0/apache-aurora-0.22.0.tar.gz"
  sha256 "d3c20a09dcc62cac98cb83889099e845ce48a1727ca562d80b9a9274da2cfa12"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3b61ca0da323c10be32bfb19af28a48b7cf393729076c3ce6608c69d79bff7d" => :catalina
    sha256 "4aec30f08b06a40ec584c4c570181e5e04909009e4bc8ce2d18f84a0e282629d" => :mojave
    sha256 "0a1b506e5d75c9fa8d587bfc9945e78c9cb5342c17a4062d18aafb942e111eca" => :high_sierra
  end

  depends_on "python"

  def install
    # No pants yet for Mojave, so we force High Sierra binaries there
    ENV["PANTS_BINARIES_PATH_BY_ID"] =
      "{('darwin','15'):('mac','10.11'),('darwin','16'):('mac','10.12'),"\
      "('darwin','17'):('mac','10.13'),('darwin','18'):('mac','10.13')}"

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
