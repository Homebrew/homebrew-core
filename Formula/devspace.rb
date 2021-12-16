class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.18.1",
      revision: "2f47f02edcabbb94dd571f561db438fbdc932a86"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5ace616008a09e53d36b70088d26e09544ce71fea891f445cd9ace6a32fce6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca3e34b69067549d122b4677fb17be9ab0f1dfa3170196b3aa8b95e6f3c4435f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8b2b7be70cd170f4899a638754257fdf708272c4702065ca4558fd2956c0d87"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bd18579477f4e7020bea87e8c35f3b0ee6dfddc2711003b64fef98118b02557"
    sha256 cellar: :any_skip_relocation, catalina:       "280256cec7164c3a4d8b79a4ec4ef925e71745dbfb8d4f411fd3bc77be158de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038361eab6531e57d78e2e213fe3ec62bb82cd764b2479674e1fb78f3a0b9504"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
