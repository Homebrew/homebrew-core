class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/kubernetes-incubator/kube-aws/archive/v0.9.6.tar.gz"
  sha256 "cde5ce0d1a72361ba0011092fdce7966eda2ce0337b801dbbdb150fde971afb8"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd7c728101b81407aa2cc09a27d7e85d42fdd0726dfccd041fb7f7b34271ef02" => :sierra
    sha256 "8f9269c178f2ec2eea325bc3b5be960964f99006b06935e9552bcecd7c05a537" => :el_capitan
    sha256 "7a59866cef92fbb090ad5311e4bb0f1b05b04efbfc052da4792ff8e6eefd5cfe" => :yosemite
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
