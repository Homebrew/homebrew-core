class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.0.2",
    :revision => "e84a79e28334ceeac7826efc251ae111c05d4edf"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2ebbc116b3d0d4bb78d6e063a112f7b20d048208e32dce1a1810f89a2beda67" => :mojave
    sha256 "c7b5969bef31ee6a290dee4dc0a15be1a2a183b88b93051665c8584845da61eb" => :high_sierra
    sha256 "6a3dc5f610dba1e2dc35f3bdaf8d69607bbbc73976e2b8c43a2aeba6171a8603" => :sierra
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
