class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.1.1",
      revision: "9cd3723afbf14d488a208b0dfb301f9670a51c92"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "908e8c83c2ea05e318f2cd15ec1f40585dd261e6fc76c4cabc7792d4a6034abd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fa43ab0739d5af40b02bb390a8af7733e56eb5882ab43f7481a0cf889526db1"
    sha256 cellar: :any_skip_relocation, monterey:       "464fe18b926bd50bf93aa0647767ba801382a1561f083a8fed533fe5a9dbe4c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a40491bd4f5740019176eaea1797a4b08343122284332275c249ed3f0e50f11c"
    sha256 cellar: :any_skip_relocation, catalina:       "5e5aaaa9cb7e8df2f6137117f7aa30c421072da5419fe63ddc3fbf201902c235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "837921bce7372fa47b3cc42773fbea84950eb56fd44c6708f84576efd5200fea"
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
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
