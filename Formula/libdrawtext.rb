class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "http://nuclear.mutantstargoat.com/sw/libdrawtext/libdrawtext-0.2.1.tar.gz"
  sha256 "d283d4393381388f3f6dc91c9c385fcc49361aa89acc368c32db69393ffdde21"
  head "https://github.com/jtsiomb/libdrawtext.git"
  revision 2

  bottle do
    cellar :any
    sha256 "62d67858d4ac988f9b1c0717640061ddaac3d07253f833346ab03b5b95523e3d" => :el_capitan
    sha256 "3ec19e5df4406d47abe45f9c630b7bb78648cc1955d3b220ed53b0c010595f8c" => :yosemite
    sha256 "d4fe6c0cc2f75c6e41c7a2a39dec07dedf8e6122fe7069558ec2468334ec55fb" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "glew"

  def install
    system "./configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"
    system "make", "install"
  end
end
