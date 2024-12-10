class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 arm64_sequoia:  "9e8b7be5a60940996e39a2290dadf2fe4b07ee78b2cac15d504bcffe0de099da"
    sha256 arm64_sonoma:   "63b8d1d033d12bfb0d5a8dadbf8e25d8c7735f31b634cc51ad76551c10f79e91"
    sha256 arm64_ventura:  "827d02ce978922120cdb8dc135defbe0465060ee8c7d3c778def40fde470701b"
    sha256 arm64_monterey: "8a3e25918187a5b2dafb7f6e243d4c5a4e02aa7912b35f6e056f2a0717356118"
    sha256 sonoma:         "c3150ab07306875bb647bda016781a47e903921e3904d121bbe175a285e42d53"
    sha256 ventura:        "81f66ea19acbcb1def8d9069fcb8562ff2d50518e9bee5197eb10fddcaedce39"
    sha256 monterey:       "5255bb5cc6b4dc2b80d6b09666d16753856cb50fbe92b88cf5673013ad38161f"
    sha256 x86_64_linux:   "d92c190f521278e03b0a848bbb481092dcda2f68ffb85692f0c355da856faf75"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git", branch: "master"

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
    ENV.cxx11 # to build with boost>=1.85

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
