class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://gource.io/"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.56/gource-0.56.tar.gz"
  sha256 "332d89b9a979b17417fbce0edd72b19914f1409fd126a13d11787d0e15dc0d79"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "195d55d440abf1c3e5104a9a672d5bc2e26493ed55b7f8082b491b70f4bd8114"
    sha256 arm64_sequoia: "bdc1ba6b4089ae9296e1172d7ec5b6e0a1e641ea047d21fe43db0cb6c5836a4c"
    sha256 arm64_sonoma:  "c1b92f684ac3635b9f0f7a54a5735f42ba3f65a42de81af94c75006e6207a915"
    sha256 sonoma:        "892e81a39c48e764d9cb54db41544789e29e22578392c6a05ea560aef0b6d2ec"
    sha256 arm64_linux:   "0d8a1d48795700cc8d69560330eb550bdb6dd68e3bc05b0630e28bf91dcaaf97"
    sha256 x86_64_linux:  "c042625f61fdcafba8f37a0bfd60181d7ed194101323ab408806c8d5b59a4425"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gource", "--help"
  end
end
