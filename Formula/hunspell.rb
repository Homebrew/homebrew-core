class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.7.0.tar.gz"
  sha256 "bb27b86eb910a8285407cf3ca33b62643a02798cf2eef468c0a74f6c3ee6bc8a"
  license "GPL-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "057006a24f29ef2568bf8254c8514cef3e34f34f2d6b32e2c0b7512dc07bc89f"
    sha256 cellar: :any,                 arm64_big_sur:  "8d48ffd83009503b5a2c1b968ddd930e80f41731e02576d6dfea2f53fc50d97c"
    sha256 cellar: :any,                 monterey:       "ff7ca6c9c4cfa932414609b4b68c0adddc8816804910658deccd8796e7a7ee85"
    sha256 cellar: :any,                 big_sur:        "20b0f5dc7973a4cca3a8c3ea5778938d169bde2d183210f64526df8bca9512f7"
    sha256 cellar: :any,                 catalina:       "d5144178eba9ff325c297a5a0ae05f1caa9b1d567803250d5dbd86876e0718a3"
    sha256 cellar: :any,                 mojave:         "eaabf6b66c21a94a7f6810287ff84e83fdef0ed6d3db635c8ad2c810d9f84d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b57b04052406ed148c7c44e045586787293ecc9c27701e2e9c6308cdd63f3b9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"
  depends_on "readline"

  conflicts_with "freeling", because: "both install 'analyze' binary"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def caveats
    <<~EOS
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
