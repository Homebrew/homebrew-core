class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-3/dosbox-0.74-3.tar.gz"
  sha256 "c0d13dd7ed2ed363b68de615475781e891cd582e8162b5c3669137502222260a"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f571b7da43fc854f8461b1858707d83de20956f88b1dfddc1be01d274c523b1"
    sha256 cellar: :any,                 arm64_big_sur:  "009dab922218da32e74e950fdf0d76765daf0381e0141bd7f260358c99bd3fb7"
    sha256 cellar: :any,                 monterey:       "778c92ee3958eae4fcccbddfa8563bd84abe7e2d6c9b553ad824cfbc389b75f0"
    sha256 cellar: :any,                 big_sur:        "ed35e2b0e24624b888f33b28e08b6b251ce0857dc29d35c66fce6551840eef33"
    sha256 cellar: :any,                 catalina:       "c8eea7e3be337405f4b95fccf2191c728a5b0f1c0f5baae0c8702e5911355508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6483258c6369d1e398a63f809d4695ef0bc42057f90d622f4378f9a66b6e1b9b"
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libpng"
  depends_on "sdl12-compat"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
