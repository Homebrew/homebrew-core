class KubeAws < Formula
  desc "Command-line tool to declaratively manage Kubernetes clusters on AWS"
  homepage "https://kubernetes-retired.github.io/kube-aws/"
  url "https://github.com/kubernetes-retired/kube-aws.git",
      tag:      "v0.16.4",
      revision: "c74d91ecd6760d33111dc8c7f8f51bf816424310"
  license "Apache-2.0"
  head "https://github.com/kubernetes-retired/kube-aws.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f04ba02f28cb91e0abfb59c82c1231b6094ea944b70dd815a903448bfeea470b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7af14149a6b45de2067d7fbb256bcc452582134eda27688a82527d7a7a074b41"
    sha256 cellar: :any_skip_relocation, monterey:       "13b994d0e98d81cdb8a80180ae0ae2e66030013412044f519de39be785b112e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e8c892bc74895bf9567f96ba0d27d74b206197f20bd6d348c96732984dad507"
    sha256 cellar: :any_skip_relocation, catalina:       "1c5004445c0be8fd055ff78439bd3c0b413cd56247385c1453c5956fbe9503b1"
    sha256 cellar: :any_skip_relocation, mojave:         "f05e8f3cfbe5f8c17f2cd6d3a854b7c329d7f922f03271bb36ca8497589ef7d4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5172a4ad55d3977c81d405bc67d91a35ead719e24c555d5843529d2489323d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34fad4681f7bd9006dd5a6c8e4c482244dd27d881e5c6ced41cd4a61722df064"
  end

  # Fork can be found at: https://github.com/kube-aws/kube-aws
  deprecate! date: "2020-09-29", because: :repo_archived

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
