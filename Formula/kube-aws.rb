class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/kubernetes-incubator/kube-aws/archive/v0.9.7.tar.gz"
  sha256 "f9fa80bfc71f08590bf3e268fedd5df46015d429ca70fab8d7221284efd849db"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c529a7df8b72a22bd5117d37bd845e8fb36353371399e1e6a28e6b0385b011be" => :sierra
    sha256 "0b7b0d37d1dbf64dc40ebf7b97061449c56d78c20f8bc319a9f078344027901e" => :el_capitan
    sha256 "7ae16b11b46fd63a328fccfc81093e3d6dc7ded8a8676f88b443e3848cc07662" => :yosemite
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
    cluster = {
      "clusterName" => "test-cluster",
      "apiEndpoints" => [{
        "name" => "default",
        "dnsName" => "dns",
        "loadBalancer" => { "createRecordSet" => false },
      }],
      "keyName" => "key",
      "region" => "west",
      "availabilityZone" => "zone",
      "kmsKeyArn" => "arn",
      "worker" => { "nodePools" => [{ "name" => "nodepool1" }] },
      "addons" => { "clusterAutoscaler" => { "enabled" => false },
                    "rescheduler" => { "enabled" => false } },
    }
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
