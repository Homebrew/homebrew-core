class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v3.5.12",
    :revision => "da80ef6eb617a413495c6abec1981c588ebfa414"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfea90542040b1ebce61faae4d69ea0fc2c38e582f5ec6898d8a31405659c837" => :mojave
    sha256 "d59dce4631c83bdfa091dd7b7e0e2493a49bfbdefff5b23beb0153b23d5a2814" => :high_sierra
    sha256 "84b3af3239571570eea80c4b2ea8e45e1ca064089802919d3c1bdb6a39e5adfd" => :sierra
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
