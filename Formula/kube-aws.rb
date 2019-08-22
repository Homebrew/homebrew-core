class KubeAws < Formula
  desc "Command-line tool to declaratively manage Kubernetes clusters on AWS"
  homepage "https://kubernetes-incubator.github.io/kube-aws/"
  url "https://github.com/kubernetes-incubator/kube-aws.git",
      :tag      => "v0.13.0",
      :revision => "c8b898962dcf6fd97e71f9c1b29a75e84ed66eee"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d854666b1914cf6c2f7922a5e42e940e952b6363abd25ebe8d6d8d8907efbd3" => :mojave
    sha256 "fd7ebc93a10b75e7a7198fa9c124c9879198820c911861fd52606ef51ffe31b8" => :high_sierra
    sha256 "e00c1c8a1a59bbae1d0b40ec9f62131be119fb8c328ac5a2f580127811fbe2b4" => :sierra
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
