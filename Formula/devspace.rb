class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.2.1",
      revision: "796ab32c275d37158de003e21c018a6a53215aba"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17763f56ae611a710e4c5c4bf3c41205b6b330062995e6371112f42be6d9fb8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8224a308766b9d13a45339b2135a82c8ca186834c46db2f9b9b4e7a267359565"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "086de8115b88776aba6a0db379512df31f297d96e542de3e61db9b1695f56dff"
    sha256 cellar: :any_skip_relocation, ventura:        "3fd8ba205b885416969c5b79d5855bf2ad2bedef37fca86ae78eeb428e3de837"
    sha256 cellar: :any_skip_relocation, monterey:       "326894bfba2f0852e8f312f3d2a08b712c3a28efe302debe9449fb590f45f102"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dabb965242c2859bcae2d4901bea143fe438ca1e3be814a4726d22f9a6db1ed"
    sha256 cellar: :any_skip_relocation, catalina:       "570b3838b2c8b3022084a88824d7d263a58618bf65ed74535a058a085422691f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f860f09971297f0a5d87e51a07c80c683bb473d5700416286bfbf1283e52cd26"
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
