class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.0.3",
    :revision => "2743f0af1dd51cfd340497c7476b6a2abd341479"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca2af4cafd221583b6b89ff19eb6a97210ff7c9715584d7e2842bd5a6291f6dc" => :mojave
    sha256 "66b6f3708d9410fcf0fa6c8d11911e29a4cdd99eb585fdfb781de8bce133955f" => :high_sierra
    sha256 "223f0a0a2c6fe075a32ebd07a96786c40bd7a283f568b94b67e25ca5771ddd60" => :sierra
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
