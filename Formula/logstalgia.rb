class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "27e9810c391318dc66cd73a577452e2a4cdb261409ab0a91e5f7be62993cacf6"
    sha256 arm64_monterey: "4417eb86e0840a81e4f65737b97b95c27bb4fb16cef3b06e490ea6ee02492ce9"
    sha256 arm64_big_sur:  "4e83c5c6ebc90a2b1876078a0799032aba22d0227e59979cc061cdfec1c2c073"
    sha256 ventura:        "55948f7595d2761138f3d9a15190eb3ebacf5493e9cc336e7cbb01a40fd5110a"
    sha256 monterey:       "d29aa89705294c1aa80165c7ee66d2d46d1273b972be94744e56e6b59440e131"
    sha256 big_sur:        "60c8226b514874695e821c3f35e57495f0c03a806d2daaeaf44d958340f7769b"
    sha256 x86_64_linux:   "60e89a6cc0d0e08c367c5577ebf2a42be19340f8b7e652f3fc33585e17a0a858"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", *std_configure_args,
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
