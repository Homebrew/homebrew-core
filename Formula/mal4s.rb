class Mal4s < Formula
  desc "Malicious host finder based on gource"
  homepage "https://github.com/secure411dotorg/mal4s/"
  url "https://service.dissectcyber.com/mal4s/mal4s-1.2.8.tar.gz"
  sha256 "1c40ca9d11d113278c4fbd5c7ec9ce0edc78d6c8bd1aa7d85fb6b9473e60f0f1"
  revision 6

  head "https://github.com/secure411dotorg/mal4s.git"

  bottle do
    rebuild 1
    sha256 "8a3fd76a8aed3f2ed825ee58c6e84df4b8d23c1365dec0de679d6e5de7811477" => :sierra
    sha256 "95a5871af84d0ea208e478bebd7c29bad070ed916347cbdd853d911acaf69d1b" => :el_capitan
    sha256 "4ce392506649494538c6765f10bf11f3a8cca6b3acfc64222cff5a84efa8c19c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glm" => :build
  depends_on "boost"
  depends_on "glew"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "freetype"
  depends_on :x11 => :optional

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
      assert_predicate testpath/"out", :exist?, "Failed to output PPM stream!"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
