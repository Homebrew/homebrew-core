class Diary < Formula
  desc "Text-based journaling program"
  homepage "https://diary.p0c.ch"
  url "https://code.in0rdr.ch/diary/archive/diary-v0.15.tar.gz"
  sha256 "51103df0ddb33a1e86bb85e435ba7b7a5ba464ce49234961ca3e3325cd123d4c"
  license "MIT"

  livecheck do
    url "https://code.in0rdr.ch/diary/archive/"
    regex(/href=.*?diary-v?(\d+(?:\.\d+)+)\.t/i)
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
