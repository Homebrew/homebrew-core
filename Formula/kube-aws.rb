class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/kubernetes-incubator/kube-aws/archive/v0.9.6.tar.gz"
  sha256 "cde5ce0d1a72361ba0011092fdce7966eda2ce0337b801dbbdb150fde971afb8"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d486f64d76f822d0f282d575543f1dc5008b8306deaeb3d4ee984ae1604a9924" => :sierra
    sha256 "d6f7cbe965878315250494441844d3de9bb2e0b2b7eb9d5e8d3faae3904a815f" => :el_capitan
    sha256 "e10ba1d9474a9cc8bbdafa8919132af3463f9c652ad50dd258a44e0a55723edf" => :yosemite
  end

  depends_on "go" => :build

  def install
    gopath_vendor = buildpath/"_gopath-vendor"
    gopath_kube_aws = buildpath/"_gopath-kube-aws"
    kube_aws_dir = "#{gopath_kube_aws}/src/github.com/kubernetes-incubator/kube-aws"

    gopath_vendor.mkpath
    mkdir_p File.dirname(kube_aws_dir)

    ln_s buildpath/"vendor", "#{gopath_vendor}/src"
    ln_s buildpath, kube_aws_dir

    ENV["GOPATH"] = "#{gopath_vendor}:#{gopath_kube_aws}"

    cd kube_aws_dir do
      system "go", "generate", "./core/controlplane/config"
      system "go", "generate", "./core/nodepool/config"
      system "go", "generate", "./core/root/config"
      system "go", "build", "-ldflags",
             "-X github.com/kubernetes-incubator/kube-aws/core/controlplane/cluster.VERSION=#{version}",
             "-a", "-tags", "netgo", "-installsuffix", "netgo",
             "-o", bin/"kube-aws", "./"
    end
  end

  test do
    require "yaml"

    system "#{bin}/kube-aws"
    cluster = { "clusterName"=>"test-cluster",
                "apiEndpoints"=>[{ "name"=>"default", "dnsName"=>"dns",
                "loadBalancer"=>{ "createRecordSet"=>false } }],
                "keyName"=>"key", "region"=>"west", "availabilityZone"=>"zone",
                "kmsKeyArn"=>"arn",
                "worker"=>{ "nodePools"=>[{ "name"=>"nodepool1" }] },
                "addons"=>{ "rescheduler"=>{ "enabled"=>false } } }
    system "#{bin}/kube-aws", "init", "--cluster-name", "test-cluster",
           "--external-dns-name", "dns", "--region", "west",
           "--availability-zone", "zone", "--key-name", "key",
           "--kms-key-arn", "arn"
    cluster_yaml = YAML.load_file("cluster.yaml")
    assert_equal cluster, cluster_yaml

    installed_version = shell_output("#{bin}/kube-aws version 2>&1")
    assert_match "kube-aws version #{version}", installed_version
  end
end
