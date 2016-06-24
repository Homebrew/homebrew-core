class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.14.0/apache-aurora-0.14.0.tar.gz"
  sha256 "c62a152c9e3a851e701c760f4ea50dc8ba1833299f0cbae72e0d92e7011712bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "b48f209069faa373d10ab284feb7dc83847dee45aa805d9260f1e367bcd26da3" => :el_capitan
    sha256 "c350d082b32c1c0e2fcd8387839c725b4d94c97ad517b906cebfcb63c13c5f13" => :yosemite
    sha256 "211ef89b103c5cd5c4b7aabe70bdbb297256e3e825da5572d37230857043b792" => :mavericks
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
