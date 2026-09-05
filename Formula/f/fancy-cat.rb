class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "77b537044f61970578b95e3273362dd3d260fd3e0cd6b5376cf4f1bb2e43fa69"
    sha256 cellar: :any, arm64_sequoia: "d7112461923c62ab6a8152b60d47010ce8635877cf7302f78b9ab69381090b6c"
    sha256 cellar: :any, arm64_sonoma:  "d7a5d7781bf8574737bab299600ff15f9320df7280296f49d6c96d38dfa97466"
    sha256 cellar: :any, sonoma:        "95eaf786faef157771e1077ed61ae14badd1e83699e95f83bb5850bc94999e8b"
    sha256 cellar: :any, arm64_linux:   "9e6ab36a719950e83685b4d9faaf4d47f8babc9875192238a5618d9c8231207c"
    sha256 cellar: :any, x86_64_linux:  "bafbb3b5d2f10ff0274848a3c1c9e9264906ae11d6189be283954a9e412190d9"
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
