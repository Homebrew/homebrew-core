class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.17.0",
      revision: "ac2f19c286043a623dcadd2df16a623bb0713781"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be02973223953ba00105bf0aaefb368232e39cd7c399e504201286cbba7f568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c9325c16a11aef6060f859fc7e55fc535fcd10b4b3aa47fb1b62c613f1e1f1b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d64829828897f01159e71197210bfd69316e32ea571d408f44a7b085f808dea"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9cb5cb658882eebef6af056f644514337d302be6c16c218ebc36e2a909e3527"
    sha256 cellar: :any_skip_relocation, catalina:       "de5cf62eae4fe8cdcb85c0be3e289fcb3fb4112fa3204d0142e98788e77d3538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5429d6af0eb1108cbde31bb2f4b3ad1698f66ebe11aa8e601f2ae995f90036a"
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
