class Diary < Formula
  desc "Text-based journaling program"
  homepage "https://diary.p0c.ch"
  url "https://code.in0rdr.ch/diary/archive/diary-v0.15.tar.gz"
  sha256 "51103df0ddb33a1e86bb85e435ba7b7a5ba464ce49234961ca3e3325cd123d4c"
  license "MIT"

  livecheck do
    url "https://code.in0rdr.ch/diary/archive/"
    regex(/href=.*?diary[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a366f0be6bb1d23a3c0365b4c9e3c1308a9f25fe98949faa0344bfbde84e4393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "596cf38b2aa8ef25fef5533c74673718d05150b9605f8fdd703a064eb40604a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07272e5e6d3df2aefe2401bd9adf0c2bac89011c7dcf7829a8e63eaf4f1482c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2be54322972d89253aa4036eb889863f9b76b02d4182a73ebd18e7f27f905a7"
    sha256 cellar: :any_skip_relocation, ventura:       "db5ed2d29ada410541262e0104a6cbbcef5a7a76e027e61463af6f28efe8f2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45417001ea62ec5dd28ef4620cc0f78da5d100b02e922c5948e961cb24328671"
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
