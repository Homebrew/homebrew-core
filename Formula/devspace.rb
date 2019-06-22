class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v3.5.8",
    :revision => "3efff768ae61fffbfb224a51406ba54e6b670a02"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4fd2de185f666e08638c9fb26aca9bed0fbdd1243bf9e6e5e7a678a2d975843" => :mojave
    sha256 "d03af3dd5f4b7dd11cd9a2e15b7025bbcb014a2fabd35090880216da300dc1b0" => :high_sierra
    sha256 "3e80c774662a3df41c0ce0e974dac983e58ce9977a0de0d8508e01edbd52da28" => :sierra
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
