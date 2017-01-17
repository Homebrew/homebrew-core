class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.16.0/apache-aurora-0.16.0.tar.gz"
  sha256 "e8249acd03e2f7597e65d90eb6808ad878b14b36da190a1f30085a2c2e25329e"

  bottle do
    cellar :any_skip_relocation
    sha256 "96f4818d2b60d039b5b329de3a0c535abe9d357cf2568ce5e6a03331f381831f" => :sierra
    sha256 "a040d213930834e440fee818c7608aa915cb95781cf33426355ac929c92947f5" => :el_capitan
    sha256 "f81dbf4693ca54388d6c1e1d21baab81c128240d7b82e97e9669641112c27fda" => :yosemite
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
