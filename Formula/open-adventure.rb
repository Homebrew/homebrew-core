class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.15.tar.gz"
  sha256 "489a5079b45b11b7ac6bfea42d53c6c2c02680ee5df179e22fc046b1fd727d12"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00d3f7904b7a946ae4ebedb6060c0566f415226469a803679fbdb6e1185e863e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ced5a068dad73d31d3f7bfe1c95177c6b93dac3fcbd37a5628a43d51f4bafaf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "353baf874483d1c35a80cf6ca28c3b1665887dba1d8b0e44cd5485388194b49e"
    sha256 cellar: :any_skip_relocation, ventura:        "668c40f3d213ef0b55c4840c4acc886aa299688adcac881bfc59ea11b1b45551"
    sha256 cellar: :any_skip_relocation, monterey:       "d33f363cd634406c4343d7b0b85f12d13f7659dce3e3247f476df859a6257e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c1c89e9142d4a6c6c650fae1cc178949e68cada9e3ffd3bd2cfa483bda1d465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b83aca32e9c2090a63ab5da9270c2c27c8b21ff9ef3c0d903ca343988a83c5"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.11" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system python, "./make_dungeon.py"
    system "make"
    bin.install "advent"
    system "make", "advent.6"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end
