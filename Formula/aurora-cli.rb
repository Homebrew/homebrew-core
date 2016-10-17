class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.16.0/apache-aurora-0.16.0.tar.gz"
  sha256 "e8249acd03e2f7597e65d90eb6808ad878b14b36da190a1f30085a2c2e25329e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0183b82944db056e0b61f367611076d23db7c772d5f37a4d86b3c423d02306da" => :el_capitan
    sha256 "6bc5f013f7182fab96d21fb228d96de52ca3c3329f542efec2929babf50d1cfb" => :yosemite
    sha256 "9b45a0ba82e22ff2e272c80977d047a16b5164edb0efc198ffc90ede170c5444" => :mavericks
  end

  # Update binary_util OS map for OSX Sierra.
  patch do
    url "https://github.com/thinker0/aurora/commit/a92876a1.patch"
    sha256 "b846045b2916c9d82a149bda06d98a2dabdbac435c16ba2943a90344bf55f344"
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
