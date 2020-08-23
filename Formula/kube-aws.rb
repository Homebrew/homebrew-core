class KubeAws < Formula
  desc "Command-line tool to declaratively manage Kubernetes clusters on AWS"
  homepage "https://kubernetes-incubator.github.io/kube-aws/"
  url "https://github.com/kubernetes-incubator/kube-aws.git",
      tag:      "v0.16.2",
      revision: "4c8ca963a4af9c4f1f0bde0e29eb39a9b4455f99"
  license "Apache-2.0"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15bd23749f4ee8eee545263c9a22962f7cdf7c22bbc8c44d2fa8e396947d03fb" => :catalina
    sha256 "048147da6c013e2f5a3d589c17188a3bf5b54bc7aef8ef3b887bb19521c1d16d" => :mojave
    sha256 "248c00b9ccc58108d71da68e1ff8a077b3f5d88dcace6bf1fd8439a4b7a73bfc" => :high_sierra
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
