require "yaml"

class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/coreos/coreos-kubernetes/archive/v0.8.1.tar.gz"
  sha256 "fe65c3fb72af7aa47dad07b8428eace077314edd3c129dba1fea5d3cccfaf094"
  head "https://github.com/coreos/coreos-kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3086d22bacb34718411d6d05ea67196859486362423953dbdfe7e7c377aa449c" => :sierra
    sha256 "357d7ac011e49dce3be1bfc23bb2281f12e2ba7da50dbea93bd52305601b4728" => :el_capitan
    sha256 "3e6116eddab3be537ec93546a017ca2264352fffa824a95140ab6cf9f58dc107" => :yosemite
  end

  depends_on "go" => :build

  def install
    gopath_vendor = buildpath/"_gopath-vendor"
    gopath_kube_aws = buildpath/"_gopath-kube-aws"
    kube_aws_dir = "#{gopath_kube_aws}/src/github.com/coreos/coreos-kubernetes/multi-node/aws"

    mkdir_p gopath_vendor
    mkdir_p File.dirname(kube_aws_dir)

    ln_s buildpath/"multi-node/aws/vendor", "#{gopath_vendor}/src"
    ln_s buildpath/"multi-node/aws", kube_aws_dir

    ENV["GOPATH"] = "#{gopath_vendor}:#{gopath_kube_aws}"

    cd kube_aws_dir do
      system "go", "generate", "./pkg/config"
      system "go", "build", "-ldflags",
             "-X github.com/coreos/coreos-kubernetes/multi-node/aws/pkg/cluster.VERSION=#{version}",
             "-a", "-tags", "netgo", "-installsuffix", "netgo",
             "-o", bin/"kube-aws", "./cmd/kube-aws"
    end
  end

  test do
    system "#{bin}/kube-aws"

    cluster = { "clusterName" => "test-cluster", "externalDNSName" => "dns",
                "keyName" => "key", "region" => "west",
                "availabilityZone" => "zone", "kmsKeyArn" => "arn" }
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
