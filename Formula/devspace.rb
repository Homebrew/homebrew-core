class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v3.5.18",
    :revision => "06a0eab8c1ef6a14d1d4287b491ce4815a15f7bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5442aed015c34c929687ed090ad8bdb3506ac58b7159f04f55718720f7fe173" => :mojave
    sha256 "2808729e8183918d304f1df34ce2abaa7c74068a1ab48b68f3c99dce5bb66414" => :high_sierra
    sha256 "5fbd4c6e1e843350be1bde60bd493b9e294ead2012047cc1d08fedf6e95a8c20" => :sierra
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
