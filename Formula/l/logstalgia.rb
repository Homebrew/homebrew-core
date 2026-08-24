class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.5/logstalgia-1.1.5.tar.gz"
  sha256 "028936e9f663c877d6969ad25f145c7b420797e9a3e01c6c184815ed8309f481"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/acaudwell/Logstalgia.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "968fb21de628f1134ff9658143f311a4308d50a70640c56e4cafaaabaa50d6dd"
    sha256 arm64_sequoia: "ad39fc4b76c2fa15e0dd1c96a7d68138854eac7c140ed672286921e230de1d16"
    sha256 arm64_sonoma:  "d1451ec4b1fc58006c7913ef852c0301d869f3e42d54e8b290f4fc14ec7a6b28"
    sha256 sonoma:        "e2e882edcc92ff5dfad8c032afe244879bae0fd7eddab3fbe1ef5e610c9e9ce9"
    sha256 arm64_linux:   "f77e6de85bf093f3ff77be706f0af9d58d5d44e0dead8dc21b81d27dab3b6aaa"
    sha256 x86_64_linux:  "8cf25fc1623b2e4e9757a8e63dbd70f13a4f255c66f27849631d6a0b806809f7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "glm" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2-compat"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.cxx11 # to build with boost>=1.85

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{formula_opt_lib("boost")}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
