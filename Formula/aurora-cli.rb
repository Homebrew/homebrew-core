class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.22.0/apache-aurora-0.22.0.tar.gz"
  mirror "https://archive.apache.org/dist/aurora/0.22.0/apache-aurora-0.22.0.tar.gz"
  sha256 "d3c20a09dcc62cac98cb83889099e845ce48a1727ca562d80b9a9274da2cfa12"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f2945196eccad73b84c7d5c3e23b0dea0d09b0aad3d0bde1d4db8c3481546635" => :mojave
    sha256 "dcb6e76159d6d41b2e7dd3eb83ab9c64fee3ea36cf4efa78f2a5019b30d3da19" => :high_sierra
    sha256 "aec69c7cb0a23373f583fa124add6cb68b6fe4af7faa32e4c8167b8d3e886f74" => :sierra
  end

  depends_on "python"

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
