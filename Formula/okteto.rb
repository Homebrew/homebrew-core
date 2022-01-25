class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.2.tar.gz"
  sha256 "75b9d033bf7545274cdbd01d82bf9242b61d419670407c633009e16149beac7a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d07e84aa8b988fdf1a842ed92fc46051de50e4ca0984355b0b8a39372d7c164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67e7187c1575ed07b07e7a6d0b7b28022c5373317eea6667a299c423023dcafd"
    sha256 cellar: :any_skip_relocation, monterey:       "c26f2c0630b81b93dbaeedae7f1d7d6c9bbc258282ad5b1eb006b1d0026e453c"
    sha256 cellar: :any_skip_relocation, big_sur:        "be8ed38e542a744e5e4b759e77de5910c348ed6a7cac9dc435d8ac8d5caa5e3a"
    sha256 cellar: :any_skip_relocation, catalina:       "5399ecd475d38dbae42a511845c9764ce5dfead3938f04a677f8a49082a526c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272447cfcd2e57d3472ba93dbd06e17b872ba287f270d958b51613e2546e348b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
