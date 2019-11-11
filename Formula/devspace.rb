class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.2.1",
    :revision => "5e9fbc5e0f37aec72a6356f8beec4a27f697dbae"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb09ffd1ba226619d72be35ea7a69684d0027c26b0a16722c5e09972c594827b" => :catalina
    sha256 "1b6391f2bfbf7c5a06b1d20a681c2923a666209c51335923ca9df2366c66274b" => :mojave
    sha256 "354ce494485d05b2a270f53faebcf04cb20315577e519be882c5408b1de364f3" => :high_sierra
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
