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
    sha256 "1c5004445c0be8fd055ff78439bd3c0b413cd56247385c1453c5956fbe9503b1" => :catalina
    sha256 "f05e8f3cfbe5f8c17f2cd6d3a854b7c329d7f922f03271bb36ca8497589ef7d4" => :mojave
    sha256 "5172a4ad55d3977c81d405bc67d91a35ead719e24c555d5843529d2489323d79" => :high_sierra
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
