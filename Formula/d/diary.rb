class Diary < Formula
  desc "Text-based journaling program"
  homepage "https://diary.p0c.ch"
  url "https://code.in0rdr.ch/diary/archive/diary-v0.16.tar.gz"
  sha256 "9140762d44251ebce08d5ae45878a30fc9c35dcdd98fe64da618cdd2062552dc"
  license "MIT"
  revision 1

  livecheck do
    url "https://code.in0rdr.ch/diary/archive/"
    regex(/href=.*?diary[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cf6dc0be5b3beea462918ef2b58d2c94ecec01aba46b260a85772abbef73b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4d8011263079585a4927de9a321597b04e522c33940059d1a97b9f31acf8763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "891d2197e94e6598c94359a6733c1962541e4f031747b09ee3d1222250136c69"
    sha256 cellar: :any_skip_relocation, sonoma:        "d51e5e2b94e5b9dc1785e7aa078d3b172efec352cdec902868d9b6b4a98a9449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88308136c0405f059f6e90173f4b8ff9416a752585917d144eb4818f2243b4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b704142ff01e044dcdec4d07de67dc87a5a19493359cddeea44652d4de1ce193"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "install"
  end

  test do
    # Test version output matches the packaged version
    assert_match version.to_s, shell_output("#{bin}/diary -v")

    # There is only one configuration setting which is required to start the
    # application, the diary directory.
    #
    # Test DIARY_DIR environment variable
    assert_match "The directory 'na' does not exist", shell_output("DIARY_DIR=na #{bin}/diary 2>&1", 2)
    # Test diary dir option
    assert_match "The directory 'na' does not exist", shell_output("#{bin}/diary -d na 2>&1", 2)
    # Test missing diary dir option
    assert_match "The diary directory must be provided as (non-option) arg, " \
                 "`--dir` arg,\nor in the DIARY_DIR environment variable, " \
                 "see `diary --help` or DIARY(1)\n", shell_output("#{bin}/diary 2>&1", 1)
  end
end
