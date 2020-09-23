class KubeAws < Formula
  desc "Command-line tool to declaratively manage Kubernetes clusters on AWS"
  homepage "https://kubernetes-incubator.github.io/kube-aws/"
  url "https://github.com/kubernetes-incubator/kube-aws.git",
      tag:      "v0.16.4",
      revision: "c74d91ecd6760d33111dc8c7f8f51bf816424310"
  license "Apache-2.0"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2985bd4c4175b626c943495a81b29b4de86e34274ac094d741c7e0fbf9462b9e" => :catalina
    sha256 "b23f734a2c61dd01b4d188f8894430265b58096d23eb4cf4b2fe0d443765bcc7" => :mojave
    sha256 "a17474237622bf8f4be4843cc8e49fa264f43d37f597116bc0352c7bcbd04f5e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "packr" => :build

  def install
    system "make", "OUTPUT_PATH=#{bin}/kube-aws"
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
