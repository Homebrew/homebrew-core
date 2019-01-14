class KubeAws < Formula
  desc "CoreOS Kubernetes on AWS"
  homepage "https://coreos.com/kubernetes/docs/latest/kubernetes-on-aws.html"
  url "https://github.com/kubernetes-incubator/kube-aws.git",
      :tag      => "v0.12.1",
      :revision => "88982344e9650628a57ea7fb97c13a577d3fcd17"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0381aaa4d176fedbb13f419e3ed64ec00b3cd24b81466eb8311259b20c5f2ac" => :mojave
    sha256 "2c39afb39ef374156027e8fca4a8979797a7f39d8f5173a65310d257707608f3" => :high_sierra
    sha256 "55b1abb960f8c38e95b68cad8d0ba2cc15765c43aa4ce0666b6e7f6f7dbf8a6e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/kubernetes-incubator/kube-aws"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make", "OUTPUT_PATH=#{bin}/kube-aws"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/kube-aws"
    system "#{bin}/kube-aws", "init", "--cluster-name", "test-cluster",
           "--external-dns-name", "dns", "--region", "us-west-1",
           "--availability-zone", "zone", "--key-name", "key",
           "--kms-key-arn", "arn", "--no-record-set",
           "--s3-uri", "s3://examplebucket/mydir"
    cluster_yaml = (testpath/"cluster.yaml").read
    assert_match "clusterName: test-cluster", cluster_yaml
    assert_match "dnsName: dns", cluster_yaml
    assert_match "region: us-west-1", cluster_yaml
    assert_match "availabilityZone: zone", cluster_yaml
    assert_match "keyName: key", cluster_yaml
    assert_match "kmsKeyArn: \"arn\"", cluster_yaml
    installed_version = shell_output("#{bin}/kube-aws version 2>&1")
    assert_match "kube-aws version v#{version}", installed_version
  end
end
