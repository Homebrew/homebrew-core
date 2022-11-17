class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/releases/download/v1.7.1/hunspell-1.7.1.tar.gz"
  sha256 "b2d9c5369c2cc7f321cb5983fda2dbf007dce3d9e17519746840a6f0c4bf7444"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9bc2a6289a536f8147dc07bc64df5b50ecd67b599f0039737ce49d2a09f6da19"
    sha256 cellar: :any,                 arm64_monterey: "e2b55b5d8ba672d91525b15ef165eec3bc1292e1e46ee9dbf01a069eda621a4d"
    sha256 cellar: :any,                 arm64_big_sur:  "849e8289515dc32df0e28fb66371dbb6db15d4b283f970bc1fb5067c2d9bf225"
    sha256 cellar: :any,                 ventura:        "e0a8af06b26f970b574dd6894025d756a251925e110553b4c39425b64339805c"
    sha256 cellar: :any,                 monterey:       "134ffae149cb7cef8adbf76a165219a88ba0a9057b64ed03cee8cbe22444c004"
    sha256 cellar: :any,                 big_sur:        "b4f0e1ab5c6df7381d0b62a746e40721fc432cafcba9b2d35eb4178e0f7ecb27"
    sha256 cellar: :any,                 catalina:       "1d472e55eb42c1d0029fb306813f79593b7a7924d8180613e19fd45d402bc161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687239fa7f643f582bd3bc61fa0b35eb0821ab762ea92ab5f05a625e4d64e1f4"
  end

  depends_on "gettext"
  depends_on "readline"

  conflicts_with "freeling", because: "both install 'analyze' binary"

  def install
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
      https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ .
    EOS
  end

  test do
    system bin/"hunspell", "--help"
  end
end
