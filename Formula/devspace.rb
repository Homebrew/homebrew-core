class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.16.2",
      revision: "0a34b1427d12992bec25e55f9bdf72e54baddbaa"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "080fb8c98feb9a45749e337c7403392849a79d86c8dd136ffd23e1d22d81906c"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0cc2f1a0d9e8edc05dc558fa2444e51275beaa421188525c5881530b2a06cb6"
    sha256 cellar: :any_skip_relocation, catalina:      "7d20914725b7be07ca623c3e8f34f975bfe99f0034504be7fa3bc7d93066fee0"
    sha256 cellar: :any_skip_relocation, mojave:        "645e39b86c59146187e79012366b7be27873731918208c07309dfa3dc5dd1350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a0ca9dc00dc5baa0266b631ba89af8a782f753ef2100e7bf443d3166ba203f"
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
