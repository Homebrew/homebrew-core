class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v7.1.4143.tar.gz"
  sha256 "f3620e00dc431ce202216c935d8e509cf0fdf0dd1e363eee9ec6cb64b0b182f4"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d68368627c5e8024bd3d195ecd1ea5a3f97bf4935757689f77e30a0d9e6b00b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d68368627c5e8024bd3d195ecd1ea5a3f97bf4935757689f77e30a0d9e6b00b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d68368627c5e8024bd3d195ecd1ea5a3f97bf4935757689f77e30a0d9e6b00b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e724db9d29de42a8de6885b3f49e793d503a9c7b84d4db10d91350cc506e2a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74a572973f6dc72ae7f4fbdf884bdbabe0b60f5c7f7cc6253868f204ab7f91b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8890203346db7bdf131d65f07a178a3c6996f9b33c67dcf7d36eee47119a598"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
