class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v3.5.12",
    :revision => "da80ef6eb617a413495c6abec1981c588ebfa414"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cec84d9f2da47f7ef44ec189d314a5e0ae74aaf4841361308e1bcce59fbb603" => :mojave
    sha256 "2493e3f744450caf23e67375123fde533c1293b7aae3e6239af6080d38d0ef30" => :high_sierra
    sha256 "833cf35c68b7960af2cd62337a548a68c761859b8009fec70069b2bbfb8ba6b9" => :sierra
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
