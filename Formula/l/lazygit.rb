class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "b8507602e19a0ab7b1e2c9f26447df87d068be9bf362394106bad8a56ce25f82"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbdb434e7d8a11ea5d58815ca7640b5fce8f72228b057281de3bd5df2bee8aa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbdb434e7d8a11ea5d58815ca7640b5fce8f72228b057281de3bd5df2bee8aa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbdb434e7d8a11ea5d58815ca7640b5fce8f72228b057281de3bd5df2bee8aa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "69948032b5dcb0a4946877d0537bbe7d98b37ab08f67b2d55729096309ea8461"
    sha256 cellar: :any_skip_relocation, ventura:       "69948032b5dcb0a4946877d0537bbe7d98b37ab08f67b2d55729096309ea8461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a19c84fac75979ac5c0676bbdf2b0c52f396678eb3576afeab08e2c7f43c5c1b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
