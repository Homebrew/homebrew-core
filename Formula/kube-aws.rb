class KubeAws < Formula
  desc "Command-line tool to declaratively manage Kubernetes clusters on AWS"
  homepage "https://kubernetes-incubator.github.io/kube-aws/"
  url "https://github.com/kubernetes-incubator/kube-aws.git",
      :tag      => "v0.15.2",
      :revision => "372f6e9038b22d85bf4189317d140b046aeb5100"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db6fd1c57883d20e770f2caace08955a78e6aaa9590d18d7626b888e0734bee3" => :catalina
    sha256 "060c49234996b0b49d3816cdc769272ebd89880bcc48332a0165b1cf259a3167" => :mojave
    sha256 "0e81cd7a496635c3a4a5eb9e2dde6d78a117f0f792e0559a25336d851af63b29" => :high_sierra
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
