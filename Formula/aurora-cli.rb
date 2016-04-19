class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.13.0/apache-aurora-0.13.0.tar.gz"
  sha256 "d26c245c9ae1b3262d0bfd3e1452dc9941f1f607e457b610b95f0a0e1b24925e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8d5aee38fffe50c8740ee6923ed2436507d36ea5a08dd2b2e936dfd9225548d" => :el_capitan
    sha256 "77ad7b569d4a9bb3c270f3721961b7a228e5fce02e878d5c73557591eb4c7fa8" => :yosemite
    sha256 "5ba53fa10ce2d6d90b2b3b02ae70b989d2cef48e40996fb03914145d17adf1b3" => :mavericks
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
