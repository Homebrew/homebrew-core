class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.1.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.1/mpg123-1.32.1.tar.bz2"
  sha256 "fceb97d3999cd3d04c7f96b97e621d01a5de0a46a3d9e9ceaa87768274ea205f"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "58c3e550c5b0bbcbf67a808fd7e8eacfa438520eba0cb716d0867908cc31b433"
    sha256 arm64_ventura:  "7b0db2565a633fc6eb2b6d8c082145f787eb92f6a16a086a8fb07b12dcffa35b"
    sha256 arm64_monterey: "f9c7b552d04aade6e221bd0b9a3514f9e6bf7a2dbbc3e4a8acfe2f1bb5947d5a"
    sha256 arm64_big_sur:  "4216d2721eb01f741304c853d31abc34c7f348bdc39de5a65164e545a9fd86c2"
    sha256 sonoma:         "78daac74cda381424f521cf10f6a9c303547826b4364b0461df2f13ea66ec43f"
    sha256 ventura:        "d3f4630322b95f6b5d47084232ef81cf07eb077cf885921eaf9fc0b3c1de7f6e"
    sha256 monterey:       "1ae9b78c91f8ff821b47fbc7141eff2489ee15b1e1622c05c6fa596a7144d772"
    sha256 big_sur:        "428ef3bebf139f1230ea3e5bef5f8f5c182c332b24526a2c5d30602dc3828d84"
    sha256 x86_64_linux:   "3ed0c5d1cbd668c32c396f87af814896744d7c6839fa441ee488ecf1eeb8ee94"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
