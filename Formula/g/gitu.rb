class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "b36673dfd2f3fb3f0fc7ae2e54940781875c1685a79fa53047a5a812fd2088ef"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a5dcf0fb34c10ab37a770c735c6c41e21300a5b39b3a0745724ac879434828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04889b42f5fea95b44e137ecc58b7831437608005f03165a3f39c4dd56c681d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2578044334e0f78d2e95748855d7b70c1141e63c0a20a1a918d00d842986019e"
    sha256 cellar: :any_skip_relocation, sonoma:        "002ee2b1d34292ff44fa31c2f7c4c7d6abf37e112d2d59a8d8d3956ceec9fa78"
    sha256 cellar: :any_skip_relocation, ventura:       "533f794d77cc81462ac96ab6a69dca9f70c661a1c4cc0f8a69b5210014aa61f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d56b63270455e28dc517dd4e5184b1c96ae9e4b7cbb9a84cc129d8044d5997e"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end
