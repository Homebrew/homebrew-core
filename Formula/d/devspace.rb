class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/devspace-sh/devspace/archive/refs/tags/v6.3.17.tar.gz"
  sha256 "3ae2196967df6d6e8aeb3313f01e8790c71ca039953e0eb046c87b44b6ed25b4"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5fea5f8ba11fcc0544023d567e3c82c37490c9e654640cb0c4590efa5483472"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b78a90264646f6956389f936aefac61ef908f58ec92532a9c3ffb868fbb0bf57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8552a9aece16a43707a00b446865888982b1c3aa7e304bc725034c907c93e15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9d135e1f9ad515b7e18d8162616849a3498f0b22265534f8cbd5158fe66a4f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "35353459bb395abe8ee06778d973027cab900036c9acd61b40fac9c8f28d565b"
    sha256 cellar: :any_skip_relocation, ventura:       "f469e26a3edc52f81e350fbc08d4501fc19299e4d944bb88717d04f1a44c3dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3254ee7d129b7ff88b8bdf39b6fd93275eb4580d3e57e9917f6b69e02b89a16e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b1fdc9dd85e2b5f7c7532bd8c94c6840d35b5792a2e0a2a2c0ef47e0db4491"
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
