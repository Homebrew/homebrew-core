class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/refs/tags/1.52.1.tar.gz"
  sha256 "c9c0bce673eb3b625b538b462e49c00ed1ee1ded1e0bad09be780076880968b5"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "186ac8f3ba4e9074efc2fbf75afeb3bf01cfc9b08a0a8c752b378b14fdd6bf75"
    sha256 arm64_sonoma:   "bba218b8268f6062f2882471629ad25a240b9d0d9dd24efbafdf2cf7818b5638"
    sha256 arm64_ventura:  "d633b03ad8d1774d29f6cd3f8a433e92074cddfffc75a9d1c4fdd3a1addb2ef0"
    sha256 arm64_monterey: "115682347106093089ff1f3b045a8c5e7691bcb2b514b8792e64c4dff704ade6"
    sha256 sonoma:         "d0d8b9beb96c6ac06a66dc9dae3fce6a5106aee96141c0e17ce92d5298d5bc05"
    sha256 ventura:        "dc19708fed0ce2cd8dfcc3d8deb2b256408b7b453ffa23aba585486cbfcdf43e"
    sha256 monterey:       "0579323fdd9048d6170abd75af16065cd958bcfcf45bfeb59c6e6318af8b706f"
    sha256 x86_64_linux:   "baa896c57a6cc6a9c5d528bab2c67c828715115e4cfb83f71dda491e312fb3ec"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "fltk"
  depends_on "libarchive"
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
