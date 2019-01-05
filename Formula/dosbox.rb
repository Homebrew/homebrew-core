class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-2/dosbox-0.74-2.tar.gz"
  sha256 "7077303595bedd7cd0bb94227fa9a6b5609e7c90a3e6523af11bc4afcb0a57cf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "774439cdc0d5d507b3064a5460d51a2ae63fcc8b6a8835ff1bb7174ccf5f72ab" => :mojave
    sha256 "020b7eb5e2890b3ec6ce717ad7dd873805e9e1fcbb9c6098ab977f0a9a95afc4" => :high_sierra
    sha256 "5f73e9f5035286b4cfbb17c29f5098dc1fe21653654f731ee8125fd532280601" => :sierra
  end

  head do
    url "http://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libpng"
  depends_on "sdl"
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
