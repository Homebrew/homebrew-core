class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.18.1",
      revision: "2f47f02edcabbb94dd571f561db438fbdc932a86"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f919eb044db50626bbe0de47eee854e4daab42016b99b082cac7dbd37530a42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586203a9eee67d1ccb7fb4c66da062a5e6e18176da8525575c010aecb03314f3"
    sha256 cellar: :any_skip_relocation, monterey:       "0262e57b28b4b6a44c57fe6a3685fa4fae14e6d1160d5a22166be2c456ffe1e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "370e6f3dee62d12be84a44cfb9efb81b39bae9c56d7106bfdde15cc0c2387876"
    sha256 cellar: :any_skip_relocation, catalina:       "0db47bd864fff3ac88882beb6934dabbb607c4626881a582674f9cc49d3d38c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34caa42a62e6cd52ad7f9ddbd813d166dbb5b1d84e3ad84e239d0eb1e4f6fba0"
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
