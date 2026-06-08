class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/refs/tags/1.53.2.tar.gz"
  sha256 "7783d2673ad496109e7dd3d75756cfef30c5b400409131b83b45c2fa3ddd735b"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d433e13be22c6651a8a1ad25e011a5b3f5340fbd29f3f58a88f168d0bc3ac76c"
    sha256 arm64_sequoia: "d9155957178136cfe1e8494ff9ba1ffe7841aa452540d3677491a714a45043d2"
    sha256 arm64_sonoma:  "289266bf2f32e6dca98e612a1896f385bd7a44cd6706fc3a0e50ace17af3e148"
    sha256 sonoma:        "d2118e22924e3c4f428a954f8230df35d049726daa7b501af2f75ee3f7c4dfbc"
    sha256 arm64_linux:   "eab980f6188ad357386a163665909f24049db02e743bdf3ccffbfaf98bbed5fa"
    sha256 x86_64_linux:  "4c258b217dc499e3f126049d71a9e6e1aa8e5863154563ae692d011997347508"
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

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
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
