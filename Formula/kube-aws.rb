class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/kubernetes-incubator/kube-aws/archive/v0.9.9.tar.gz"
  sha256 "4ad421cb58913c27b9f297161eb87b0587f8420d6f0573cee052b17370c519aa"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9552e54a302fb9514e05e2332e652ac4840a5175c583ca397cd655d6ada29f91" => :high_sierra
    sha256 "43b4567874d330c91191d155c699c9a7b5522246bc5fd204954182a5f9a04b50" => :sierra
    sha256 "c27239463b5d9d28c3adaa0bf5e112637b3a266bf28bfb97b076d952c9d24e53" => :el_capitan
    sha256 "4bde1b4c7934815860f2e94731b9e70843f6d2bcf79a886f96dcb9f47be1d057" => :yosemite
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
    system "#{bin}/kube-aws"
    system "#{bin}/kube-aws", "init", "--cluster-name", "test-cluster",
           "--external-dns-name", "dns", "--region", "west",
           "--availability-zone", "zone", "--key-name", "key",
           "--kms-key-arn", "arn", "--no-record-set"
    cluster_yaml = (testpath/"cluster.yaml").read
    assert_match "clusterName: test-cluster", cluster_yaml
    assert_match "dnsName: dns", cluster_yaml
    assert_match "region: west", cluster_yaml
    assert_match "availabilityZone: zone", cluster_yaml
    assert_match "keyName: key", cluster_yaml
    assert_match "kmsKeyArn: \"arn\"", cluster_yaml
    installed_version = shell_output("#{bin}/kube-aws version 2>&1")
    assert_match "kube-aws version #{version}", installed_version
  end
end
