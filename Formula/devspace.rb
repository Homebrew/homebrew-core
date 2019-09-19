class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.0.1",
    :revision => "cd8d7b64d31e309c1e3197438db85b47f9e37662"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cfc93abbe994eb08b5a89904ea2b1e08c82f9fde491e1a2092297fbcb15fc88" => :mojave
    sha256 "39152af371e915f8565c46566d1813c28f7650dedb80580835d30c2fee7cdcea" => :high_sierra
    sha256 "179ec22f0e8066e3e1bbbc83c0324fa4b067cee9b762f68d5d4e104e6e6d544b" => :sierra
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
