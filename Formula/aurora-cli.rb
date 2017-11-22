class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.19.0/apache-aurora-0.19.0.tar.gz"
  sha256 "d89ce4b67e4387b479493acb13c346cb53c2369ed33e60ea0f697135d4126c29"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ae104b5eaea19b76f661682a6c3742588ace04e72b420e35de95d843214446c" => :sierra
    sha256 "9b7fc8a05aea5bbb7f281fbc268025c3c9bb9a673249d5dc1be781bd5496af0f" => :el_capitan
    sha256 "62e565f0d65601f88b11d8c5f5bfad89d2f1661144072876fc705e50b4284329" => :yosemite
  end

  if MacOS.version == :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/21a7e7d/aurora-cli/pants_version_1.4.0_dev20.diff"
      sha256 "0f4e3dcab78974d43ff5225df68969609587656313f8e495908523f89f6cb0a7"
    end
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "./build-support/thrift/prepare_binary.sh"
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
