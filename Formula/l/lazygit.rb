class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "e4f0d4f3cebc70a802f95c52265e34ee879265103ebb70b5dd449ae791d0cbbb"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b58875f799a731405c1a697746645cc8f5e2defa75c8fda90d37d076764551b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58875f799a731405c1a697746645cc8f5e2defa75c8fda90d37d076764551b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b58875f799a731405c1a697746645cc8f5e2defa75c8fda90d37d076764551b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5e65e3a62637efdf1f8665ff5ccf2a8fce5d4cff0730be6a016d3b05ac7bfa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1955c592c72ef01a20fbec9074bb1205c04ea4ec3c84d6bb173bf00f66487f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420c80f591c47859e3245cee1f6675c18202f3a210f7bf75aa3f396b9cc01813"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
