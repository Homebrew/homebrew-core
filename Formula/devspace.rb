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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c49b9ce281bb34613c641d1437c6576ce9b032ef5cb30f8aebe7a88c40e50e16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "450f15b961a99141c09ced3b66d67fbe20b64d9546bea926c6a63d5c79821795"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bfb5e96133378d2851019913675e3aebbe21b467dd1fcddf97a6aa9cc814286"
    sha256 cellar: :any_skip_relocation, ventura:        "a813eddc7daa4ea1004e1225c1efd81c9f1ffb3a010796b97c68605843a4e3ac"
    sha256 cellar: :any_skip_relocation, monterey:       "b6083fdc36210e42d45d068ff0ef9082962d06e9110e7884477584ca9fa84b63"
    sha256 cellar: :any_skip_relocation, big_sur:        "22548cf46635abb21aa346051e23493bf89cdd79364ee98d0c602cab60547184"
    sha256 cellar: :any_skip_relocation, catalina:       "20d227c8d2b9f3fe21d5d3dca7376d8b77f08cd21869532ad62829198544362e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b8f151935dc4ecb19252051de7027aea65e80a63f66a5aca127780b4ff76f62"
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
