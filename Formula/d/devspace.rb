class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/devspace-sh/devspace/archive/refs/tags/v6.3.21.tar.gz"
  sha256 "c6e4f9d6587d77b5498d56391667c5d88b65ced06ca7e03a4ac74f600c19c8c4"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57ff205e70d113ac8b8098ab31b8b96eabd628d6c6917c8676448f5564b3d120"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6193255333fd9794c7d5bc40a1a4980439aafe60665b6dce3348dfc07acc5217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "558afbb1bf9af0830cd90a6828b5e3f11fd7e4c3db50c794f55b95a1818f4e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "41d1d6478bbf9dd35860b603db27aa98f1d1417aa651f504b59b4042c5328344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "098623bca8f2e814119b506ea570631f5691c9f52a9bcaf7b39f188f96e92a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486ae2ea7d2f5e2b0a729062d66279efddaf1aeee6768982dc32053e1cc4e087"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{tap.user} -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")

    assert_match version.to_s, shell_output("#{bin}/devspace version")
  end
end
