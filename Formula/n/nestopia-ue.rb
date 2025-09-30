class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/refs/tags/1.53.2.tar.gz"
  sha256 "7783d2673ad496109e7dd3d75756cfef30c5b400409131b83b45c2fa3ddd735b"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "3006e7d0399aed4f1240cd2b3f982b528f8ebf5d4a225ced121503f0211bc8ec"
    sha256 arm64_sequoia: "3eb9a030dd95e791e62ba88821665bf6f9f4a5a566baf954bfca299202dc26e3"
    sha256 arm64_sonoma:  "6c424cd6960a94b300fc867ea6490fd56bca30274a0a614f6f3ecef874cd55f3"
    sha256 arm64_ventura: "293e857687f8539c030b4cc0a9360eba6fc4e030d4d9bb0c50d80e6b1123ef61"
    sha256 sonoma:        "c9cb711c694e7c6d998662d6cd88cc2dcc50e892a73d21af312c6e3661ffd88b"
    sha256 ventura:       "fcf1edcf0d0471f721f03c5754ba29be767dea197a22460569b4e74f976bca9f"
    sha256 arm64_linux:   "d1fd2f20bb4390ad1ebd77c62f194e83d3f7920e2905e087addb2220a39c8fa1"
    sha256 x86_64_linux:  "b1a010553c6587a8c76f35a5b155fb08a7d710b4534ebe72e333fdd6acef388c"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fltk"
  depends_on "libarchive"
  depends_on "libepoxy"
  depends_on "libsamplerate"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--datarootdir=#{pkgshare}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Nestopia UE #{version}", shell_output("#{bin}/nestopia --version")
  end
end
