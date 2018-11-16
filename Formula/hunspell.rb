class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.7.0.tar.gz"
  sha256 "bb27b86eb910a8285407cf3ca33b62643a02798cf2eef468c0a74f6c3ee6bc8a"

  bottle do
    cellar :any
    sha256 "c53b702da330527f41225f545b60c70dfb45d4b3fc483282f91ff9277a9c740c" => :mojave
    sha256 "e220d787540d49550dae83b7f6fb1c439b2aa1a559a718d7d9453f6be2bed373" => :high_sierra
    sha256 "2b6cae66f0659142df3993cd30c4d22caf0ec8de61f038727eaf7d06d64d38cc" => :sierra
    sha256 "8b4bdf6b04972cf041748ae8e3d68f6a15dede6c830683a127badcba725d003d" => :el_capitan
    sha256 "1c19690997d3c77923691a779553e9277d9fc52fd075d79768d70e74c25cc2a4" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"
  depends_on "readline"

  conflicts_with "freeling", :because => "both install 'analyze' binary"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
    system "make", "check"
    system "make", "install"

    pkgshare.install "tests"
  end

  def caveats; <<~EOS
    Dictionary files (*.aff and *.dic) should be placed in
    ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
    provides no dictionaries for Hunspell, but you can download
    compatible dictionaries from other sources, such as
    https://wiki.openoffice.org/wiki/Dictionaries .
  EOS
  end

  test do
    system bin/"hunspell", "--help"
  end
end
