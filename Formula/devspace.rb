class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.13.0",
      revision: "1d0bf3708a28679810fe453a23c25fd40eb1b3f6"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93ca546d2ac2ad63b7eea7934c28982490e752c6257ecb072b6f5ca98a667efe"
    sha256 cellar: :any_skip_relocation, big_sur:       "791db483fd74b2e9598d436434ea113103e0c93af74d5ac8c97d49e57f199e90"
    sha256 cellar: :any_skip_relocation, catalina:      "ead276567d7680abce2711c6abcabdbb3c1d66a879d196bc3cadc0fc7d1bbae5"
    sha256 cellar: :any_skip_relocation, mojave:        "5d3a1df9b733bebeb6cff698dfde2708143bd8d8fb7406b51ed6ebb4d9b71f98"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
