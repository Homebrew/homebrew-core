class Mal4s < Formula
  desc "Malicious host finder based on gource"
  homepage "https://github.com/secure411dotorg/mal4s/"
  url "https://service.dissectcyber.com/mal4s/mal4s-1.2.8.tar.gz"
  sha256 "1c40ca9d11d113278c4fbd5c7ec9ce0edc78d6c8bd1aa7d85fb6b9473e60f0f1"
  revision 5

  head "https://github.com/secure411dotorg/mal4s.git"

  bottle do
    sha256 "8741583efddc7f67fb0963455541d3e4498e7135047f51c0f3eb25dff354e76d" => :el_capitan
    sha256 "2dd5cd85b1826f075987f00cab0a670bc8d8977c01621e403e2064968827101c" => :yosemite
    sha256 "452418c4354b088b4fd9860a0c086f03cb7cb150f84792305e20f38ebaa4630e" => :mavericks
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
      sleep 1
      assert File.exist?("out"), "Failed to output PPM stream!"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
