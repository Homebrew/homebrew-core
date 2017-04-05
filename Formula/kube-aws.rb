class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/kubernetes-incubator/kube-aws/archive/v0.9.5.tar.gz"
  sha256 "86a15c882ef63e3a24fbd96f8af0b945911b7b2092051baa397d6a5046a1d21f"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    sha256 "7b073c55de427c7f981b5e2c432400bebe73d5003d5886cf3dfdbdaadfde2827" => :sierra
    sha256 "029348d0ff9248e56e38aaf51b51502e265785c81b42efb553d5ab94032f77eb" => :el_capitan
    sha256 "262c04907593bbdfd04739d21740da4b34c4409c2294e376080965c0ac8e578d" => :yosemite
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
    cluster = { "clusterName" => "test-cluster", "externalDNSName" => "dns",
                "keyName" => "key", "region" => "west",
                "availabilityZone" => "zone", "kmsKeyArn" => "arn",
                "worker"=>{ "nodePools"=>[{ "name"=>"nodepool1" }] } }
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
