class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.4.5",
      revision: "c0743565c722d9af03bbfd8f75910ac876bf3b56"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f28fc747423e8c5679fdba280c6cc7a3816b59dc9a8b77369b23abe1c09afe37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eaa675ae8556fcde77ac19e6ff531e05d45dc4f1ad26b9b4d025ad71ee60ae7"
    sha256 cellar: :any_skip_relocation, monterey:       "a1bbfe934659a9f6f24d08009d06e42f0f97bd07453e035b8a11e6a5f00ac8d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d673a769d5008e95513cdbe27e9191cd6d511762f4d8a33ee171b9b5bb7489e4"
    sha256 cellar: :any_skip_relocation, catalina:       "e4891f258ec55835e4474cc7a988891057d20cd36ad6d20c697a2a35eaa42c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a92215d353ae0e2550ec2272edbb68bde22dc1d2e35d15b3c0bb12efabc328"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build
  depends_on "lima"

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    generate_completions_from_executable(bin/"colima", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
