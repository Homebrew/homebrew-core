class KubeAws < Formula
  desc "Command-line tool to declaratively manage Kubernetes clusters on AWS"
  homepage "https://kubernetes-incubator.github.io/kube-aws/"
  url "https://github.com/kubernetes-incubator/kube-aws.git",
      :tag      => "v0.12.4",
      :revision => "5c7bab28cb121a70b64b67ccf923f71a6e30e0d3"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b48f5a9eca66bc64edd427152ce5667067c15af9a3bfe68b320a63e051991f0" => :mojave
    sha256 "60b857313b9c75c83919762032bd9385f892c0edba7ec4238dae4012da5f23e0" => :high_sierra
    sha256 "522d12599e718e86f272ac364f94d9e514a158073a6b95bb64adeada2a83c58b" => :sierra
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
