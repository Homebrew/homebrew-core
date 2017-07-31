class Mal4s < Formula
  desc "Malicious host finder based on gource"
  homepage "https://github.com/secure411dotorg/mal4s/"
  url "https://service.dissectcyber.com/mal4s/mal4s-1.2.8.tar.gz"
  sha256 "1c40ca9d11d113278c4fbd5c7ec9ce0edc78d6c8bd1aa7d85fb6b9473e60f0f1"
  revision 6

  head "https://github.com/secure411dotorg/mal4s.git"

  bottle do
    sha256 "466588bcd0d4eabf15c8bf6d0e122d2b439455a0f426d87952d1dc0baafb0f4c" => :sierra
    sha256 "fcc1a8b93d0da0ec0c8388f0696d2796426165c4ab507aef2f311e3dab4de5fb" => :el_capitan
    sha256 "2838ce90e02e328eefaf1c777bf39fc31eafac661ac59ea10aedb7a368389eac" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glm" => :build
  depends_on "glew"
  depends_on "jpeg"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "freetype"
  depends_on :x11 => :optional

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-x" if build.without? "x11"
    system "autoreconf", "-f", "-i"
    system "./configure", *args
    system "make", "install"
  end

  test do
    begin
      pid = fork do
        exec bin/"mal4s", "-t", "2", "-o", "out", pkgshare/"sample--newns.mal4s"
      end
      sleep 60
      assert File.exist?("out"), "Failed to output PPM stream!"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
