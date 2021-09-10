class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.2.1/mjpegtools-2.2.1.tar.gz"
  sha256 "b180536d7d9960b05e0023a197b00dcb100929a49aab71d19d55f4a1b210f49a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "57f69f4a147c3e886146105b9f2ea4f6edb15bd2f5c9e3c648af5781590f1389"
    sha256 cellar: :any,                 big_sur:       "df7c071afa72c7fcb3e3abf340450d34f05ab1b81655ae57d48f4a3c516a7067"
    sha256 cellar: :any,                 catalina:      "2b41e5e3f6abf5fa6767757128b8913fa5932919a02b86aba9dc3a4c4302be24"
    sha256 cellar: :any,                 mojave:        "1c5d0fb366a3d4b0da30a2a2da4c8bc3f90cbe9238c512bfab57a4273855c98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cfd7380321fa05242d23477ea708de3c2b9019043f0a0b80c376d79323fdb1b"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
