class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 arm64_sonoma:   "6a5cae78d15328d6c651b2f01a5624626f2196ebae1f24001bd024f0f4a63971"
    sha256 arm64_ventura:  "bdc139e4fcc84125c9dcfbb1fac60fd721373d4508bda3dc2fc2d76c945e5deb"
    sha256 arm64_monterey: "aa59c0abd2e9f77bde6bb00c513e58dd56931cb17c5791b86fc7d15194b2f4a2"
    sha256 sonoma:         "d22fa10652173459c43f678a5ea259e8d24d393618bcccd72ec2b6a95ec72cfe"
    sha256 ventura:        "25e6e0bfb91593aa9baf00b93afbaa2784df85855a6b546d161b0400faa8f5ef"
    sha256 monterey:       "a2b9521a01de8ef4f5dd630d0907584ee4991e3b88689c3f3d7d11269d1926c6"
    sha256 x86_64_linux:   "221d3ffe0ce6af68feb0c4cd63e96297095dba23f4ad1162ad3dc82b7dc26662"
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
    ENV.cxx11

    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
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
