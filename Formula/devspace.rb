class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.1.2",
    :revision => "6ae5075ec9c9da923dc9e59e7c7a05b6fd5370c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "01d48b83fbd27b9771e96bda0ed026916278116b2b14120cb00ed9507ea12106" => :catalina
    sha256 "65deebbd64e08605e8ab2e21f13b8a1cd3e11b507230b1f86df550e945f95116" => :mojave
    sha256 "aa0386c0c522a02538c3442fd8604a11e9ae7edaa4ff1c5e86ec706d20cb2fa3" => :high_sierra
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
