class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git"

  # Remove stable block in next release with merged patch
  stable do
    url "https://github.com/0ldsk00l/nestopia/archive/1.51.0.tar.gz"
    sha256 "9dd3253629a05f68fb730e5bc59148cd5498cea359eff2cbf4202d1e1329bce9"

    # Fix for build issue: https://github.com/0ldsk00l/nestopia/issues/353
    # Remove in the next release
    patch do
      url "https://github.com/0ldsk00l/nestopia/commit/d57e02e19ba88d609a092da5b420432a7251b71d.patch?full_index=1"
      sha256 "5eba25a40d1b1cefd864e2f3fad160c438f3cb7a1257bea20bbc93c0235c1123"
    end
  end

  bottle do
    sha256 arm64_big_sur: "788e9075b691d0eb39cd89bd0951fe1510af3dc2838324f8cd7a2a982a80803f"
    sha256 big_sur:       "0d7aa5be67ed9f42a10b902706cdcb3fbbdf2dbf106f590c9a340f702cf675c5"
    sha256 catalina:      "e18051d4add14d42cc3056646dc825679718ef8c92338a411a94a5cd97a4b659"
    sha256 mojave:        "3436bde863064391e63bb7058dd15da362a18470976ed2aebf963d315748834d"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fltk"
  depends_on "libarchive"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match(/Nestopia UE #{version}$/, shell_output("#{bin}/nestopia --version"))
  end
end
