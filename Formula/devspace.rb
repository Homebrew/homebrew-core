class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.18.3",
      revision: "471bf5c24ab79ef7057a34dc5d6dd5d801356a6d"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed18d0622bc205b8e5230508f8acf2d832780ec4b5ecce98a47cd88e914c1cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa42d52afa1ccea220284a8a03dab89e882a768cc42f03131a64093fd4b1711d"
    sha256 cellar: :any_skip_relocation, monterey:       "c9cb3ef5d9de08bb8e8ee3abba4b7194165fdf92823a15b56b8a7f52565bbf46"
    sha256 cellar: :any_skip_relocation, big_sur:        "518db0b70bb48208f4adabb7a662c011f0c18be2e85c8e7f91dbff32014c8202"
    sha256 cellar: :any_skip_relocation, catalina:       "a89ef7705a23c4cd39b1d8dd6bb17f41f4e9582e811767c0e1fc485d60c1b678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e96f38e8ca0f868e98b74c8b23e9d268662c1a7ff9276cb4fdceecc6e053bb"
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
