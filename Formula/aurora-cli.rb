class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.21.0/apache-aurora-0.21.0.tar.gz"
  sha256 "4b608e5199ae72c83b0bc97569de5ed2c58d73a709f6906c3664154144438b65"

  bottle do
    cellar :any_skip_relocation
    sha256 "77da0f72e53bfb0ffdd8af48a76df391e8d16fba029cd15ec087e3fa40995c1b" => :high_sierra
    sha256 "02f7a2877b978c0b5c37e2eca609e5ac5d612465fa1d2619aa99cfc3118b8153" => :sierra
    sha256 "a97a66254586aace43a789ae73df85781bff46c3d2837a0b9ad8d07bf9358dc7" => :el_capitan
  end

  if MacOS.version == :mojave
    patch do
      url "https://raw.githubusercontent.com/thinker0/aurora/pants-update/pants-update.diff"
      sha256 "f558cf58ad54601e0b3366617b015d1a8c704bbd5af2de8f5c6299beb5b897f6"
    end
  end

  depends_on "python@2"

  def install
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
