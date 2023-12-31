class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.7",
      revision: "a722e450b316ba5747f98d3d7aa2b37bc0aacac9"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24e4467ccb001add0c2e038d663a7d1c48c928586dd9c057c4f2e8247a32286a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d8ae0e30d59edc207d5518bb0048e46f94d7420b7b6aa511d1c06452460953e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d29a775ddb8a4d30df5df6747b8fb99ded764fd4aff4e52f9f417c84ec39ad02"
    sha256 cellar: :any_skip_relocation, sonoma:         "522f8781dfc79a5010e3d439a339356414a1670c4a13a78bddbcfbbfe6b8fa05"
    sha256 cellar: :any_skip_relocation, ventura:        "ae83b2bfea4677bf63b7e5f2119bb4d2a135344ae7e44d1f1075e138da1e531a"
    sha256 cellar: :any_skip_relocation, monterey:       "7387cff9a166a69aef9a69b29174c94a822ed7cad46b032aee824e2f6e059a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e347ff25fead961c1fa582e98a656f0b89ef88a811d6035e6913c884707c81"
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
