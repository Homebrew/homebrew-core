class Lame < Formula
  desc "High quality MPEG Audio Layer III (MP3) encoder"
  homepage "https://lame.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz"
  sha256 "ddfe36cab873794038ae2c1210557ad34857a4b6bdc515785d1da9e175b1da1e"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/lame[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "59dc524bd852c6f9d5183deaf76cff3c0f8e546d96b707b4e00597f8526c8a99"
    sha256 cellar: :any,                 arm64_sequoia:  "0ae0dcb09c908b80ffbdb1bb168674e5190d6b9ae006d5282b7ab4f06eac9f36"
    sha256 cellar: :any,                 arm64_sonoma:   "a5116a219d70f3bb6728a0dfe6801413b9fd70e6c864257691cdb0ea272c2c1e"
    sha256 cellar: :any,                 arm64_ventura:  "dde2fd627f56465b34aa521ec5ea789a2b6672f0336f5f9a0b6b831342b1052e"
    sha256 cellar: :any,                 arm64_monterey: "67ee7aa900fa0b411c3731783ee53b17517145a03a90b1f35068b01d17b5c347"
    sha256 cellar: :any,                 arm64_big_sur:  "2ff2c6ad3cfd26e1ba53230631e2f04734a4638c344cce50ff0b8fc36b45c403"
    sha256 cellar: :any,                 sonoma:         "931beb6c95eab8c908ed21a041cfd6e3295e63d91c076d5d376d65a7984b09ae"
    sha256 cellar: :any,                 ventura:        "745542d02ea729f40b4919b73b2a716e21c7ff0f502068ebd25ab02edcf13ba4"
    sha256 cellar: :any,                 monterey:       "11e516ec779a6f469e9853dbdf65c57e5514177474d70f38cef9c4163b92dfab"
    sha256 cellar: :any,                 big_sur:        "6ceaf88479ce365df8c29140359984ad8debcc44898b99424b39d729e923279b"
    sha256 cellar: :any,                 catalina:       "02b6a2cbf9b902225308bc90c8314699761cbdcd13628271579f5345d8160af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e9bc793b37a72ce61d28dbbdb8dd160a0785e91b7d9ab6e964ba9e6a8a549d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8318f10b1b986d57826f0f59800c43f62d58e8d52cf9c94b8924e28739e656"
  end

  uses_from_macos "ncurses"

  def install
    # Fix undefined symbol error _lame_init_old
    # https://sourceforge.net/p/lame/mailman/message/36081038/
    inreplace "include/libmp3lame.sym", "lame_init_old\n", ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make", "install"
  end

  test do
    system bin/"lame", "--genre-list", test_fixtures("test.mp3")
  end
end
