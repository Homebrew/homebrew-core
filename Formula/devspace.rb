class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.2.2",
      revision: "1371d3eaf6778d0131d71b16556517197e7366ca"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f428288eecf8fb93961c9f6207eb204545329a98f055616d7f6b42a527e6228e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c173e5689feb2f75610ea785012c71e9278fb95cb21c2ada6f960707ac84fc85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d670591dfee193ebaf23b5a990bc4a03a2b95063ebd90bd5dec95e084ef2570"
    sha256 cellar: :any_skip_relocation, ventura:        "b1bb87304485c55c32fd4d890c2f9fa7214bd84c4491e4114d0ae4534744eec5"
    sha256 cellar: :any_skip_relocation, monterey:       "a52cd8736a56bb40fbe31b2506fbd2fb7985fcdb3a2de47e02cc135866ea7c91"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a7cb6718fd42aab68dfe3e756b8aac0a82cc458fdd33735b2af09dd35529b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b854e3cf88ee6dd991102131c96ee6ab4a8102af3683abf25eba560210a495b"
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
