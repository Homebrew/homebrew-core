class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v3.5.9",
    :revision => "446270ccda552c33b0f8390f8cb397a7f25fe74e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0260b490ecfef7c6ad4120f4988e91d7aba80c4773a2ed4ab198dd6ea0d2d90" => :mojave
    sha256 "abb34741d67ef98ef4b6e98ab2de36ed3969a3d68e7e43527668da2583f08b07" => :high_sierra
    sha256 "f47e8bc9528fd1ea0ea220b4e557d2b766b073cd99f6eabd0ff954cdf9e93e6a" => :sierra
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
