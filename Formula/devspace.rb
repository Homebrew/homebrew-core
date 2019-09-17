class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.0.0",
    :revision => "3d1b7883c4aaba0d6a063a7ca8304c1025cf6278"

  bottle do
    cellar :any_skip_relocation
    sha256 "b020230a8307110c1f6506cce8a6c28285a012c5f232594b22e7c6219bdbec72" => :mojave
    sha256 "9f9a1382ad606c760a53326537bf35e132e00deeb2260cfe354d1724758eb44e" => :high_sierra
    sha256 "96d46840e94b1a40888f3c57833233892c57015909ad7ce97c9aaf39d393cbbf" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/devspace-cloud/devspace"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"devspace"
      prefix.install_metafiles
    end
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
