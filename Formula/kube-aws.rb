class KubeAws < Formula
  desc "Command-line tool to declaratively manage Kubernetes clusters on AWS"
  homepage "https://kubernetes-incubator.github.io/kube-aws/"
  url "https://github.com/kubernetes-incubator/kube-aws.git",
      :tag      => "v0.16.1",
      :revision => "f2781f8f76de408cd7dbc9dd832bb3e364961e30"
  head "https://github.com/kubernetes-incubator/kube-aws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9886afaab6dd749d4f6ae8699c6b3e7f7f58643256cbad8c39c20bdac5be93f" => :catalina
    sha256 "2163f4ba577af7afc517ec347158be45d909eb999a0c1185a662cf83168fb444" => :mojave
    sha256 "c400eff91b8ab74770af53bd3ae522e33947da4e08f46f2040ce2fc20047af5f" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "packr" => :build

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
