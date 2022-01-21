class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.0.tar.gz"
  sha256 "0f1922f6620ee5e4ad1dd41d85d08b66926d5a8963eeb2df4f90b8dd137f65d9"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87894e0d7a952a5a1aca7cac7a5a4c8eec47ce8c1a9450d20dbd3bc14282319a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6cd22d04d625062a81d9760bb46b14fd9497f07cf13c7d90de95f0cbc97410e"
    sha256 cellar: :any_skip_relocation, monterey:       "3aed5ca0dd5909386b293c604a0e5cb834f29c909afb1bfd7af653ca8b365f24"
    sha256 cellar: :any_skip_relocation, big_sur:        "06b41014f2f687a01e21089daeadd261617666087d6cdd590f511132708e8502"
    sha256 cellar: :any_skip_relocation, catalina:       "f0386333f21536ebd602dca43b4cfadddd38d8d8cfdfc93c8608985f6fd5a7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00fe94e9c7ae8cea9151a2cf3abebcda32012a9dcfa23fa10d7e9c6dfdc3a153"
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
