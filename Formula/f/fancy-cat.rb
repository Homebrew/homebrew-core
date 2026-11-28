class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"
  revision 8

  bottle do
    manifest_sha256 "9215f12b85752def754216e1515f20980fd7da3c1daac3752b13018f4b463492"
    sha256 cellar: :any, arm64_golden_gate: "80b0a5bf5b84b49096f78203219000c11567aa29ac78fe6db13848faba3ba27a"
    sha256 cellar: :any, arm64_tahoe:       "096a5751b097142d9246d2cd2c41bdee6d9eb188d54b7907f1271ee35d6f9924"
    sha256 cellar: :any, arm64_sequoia:     "bb1dc539a126e83ec22fc690efed1b853aabf5fac60bebf2d1efe29bb661016e"
    sha256 cellar: :any, arm64_linux:       "5a9c1f66f882c42f42fcdebf7dd3c50a6d22e60554bb52596aaa03b3e0ff8b7f"
    sha256 cellar: :any, x86_64_linux:      "2d4e96af9c9709fd3e76db9c02c19f71af8a1347ba22ac8a0e107d2dba45275b"
  end

  depends_on "zig@0.15" => :build
  depends_on "mujs"
  depends_on "mupdf"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
