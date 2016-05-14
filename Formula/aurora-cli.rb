class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.13.0/apache-aurora-0.13.0.tar.gz"
  sha256 "d26c245c9ae1b3262d0bfd3e1452dc9941f1f607e457b610b95f0a0e1b24925e"

  bottle do
    cellar :any_skip_relocation
    sha256 "006b9d33d98736ebee6053b8530c22d9a188a2e1e7ad019d7cdece96a86ceb7c" => :el_capitan
    sha256 "5c972f89ee513838173c9641ee01f81ddaa40b02d98bb05b462a5fddc6838b7e" => :yosemite
    sha256 "bc4c5caac41a770e5d25bf05b2a52fddda76db9628fe17f8d4952039ede45ea9" => :mavericks
  end

  depends_on :java => "1.8+"
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
