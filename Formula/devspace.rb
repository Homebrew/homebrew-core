class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.1.2",
    :revision => "6ae5075ec9c9da923dc9e59e7c7a05b6fd5370c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "844fc0864bd803899469f0bc81904a3f760d99734a999bdb88a6b042d8c4f15a" => :catalina
    sha256 "97b67502ea40575f2546dfad0f6ba29ed16c82a870e8d531a46d64efa206ed07" => :mojave
    sha256 "6f7985661fb95692e1a49f963392b2d46ed0f7e64b1a3ab00bf2b996f873b28e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath

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
