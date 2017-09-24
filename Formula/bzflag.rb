class Bzflag < Formula
  desc "3D multi-player tank battle game "
  homepage "https://bzflag.org"
  url "https://github.com/BZFlag-Dev/bzflag/archive/868a2be7cba3f2b706876f526cf8ba4c76e461d6.tar.gz"
  sha256 "17bd397a12b40f09f1d1a785266c9bc6b832153d18dfc87e44a5caaf40f94fc2"
  head "https://github.com/BZFlag-Dev/bzflag.git", :branch => "2.4"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "c-ares" => :build
  depends_on "libtool" => :build
  depends_on "sdl2"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    system "file", "#{bin}/bzflag"
  end
end
