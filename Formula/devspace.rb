class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.0",
      revision: "358eb5888c16c83c3142d86c114466b4d703c232"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79113395c713535d2f8c7828e8c01062f71c5eaa4ce6209de14e2dc98634c8b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "092bdae23e7cb1b16b75123b258afd767b52a18e96ba57f602fea7d9e3fabc13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9e1f07ceebeb9061360828073906360818ae52ce78bbe85285771c5626e73db"
    sha256 cellar: :any_skip_relocation, ventura:        "9babde43483f55384e35eaa643cfbb30822b81514fd362db54e74d4a391a40e7"
    sha256 cellar: :any_skip_relocation, monterey:       "e9e40ee04330e9391e5df4aff9195a937569966bfceb8f8ff34b0717c1ba85df"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a55cea36a0b019934e2e8c04b73050b29d213742bbefe7be770893678d6bf4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68971d2d5ae5a9c1926789fe6723d0d99ca9f47190a8e2e2c970d4f74e8ad85"
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

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
