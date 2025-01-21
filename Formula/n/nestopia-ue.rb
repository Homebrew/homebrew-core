class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git", branch: "master"

  stable do
    url "https://github.com/0ldsk00l/nestopia/archive/refs/tags/1.53.0.tar.gz"
    sha256 "27a26a6fd92e6acc2093bbd6c1e3ab7f2fff419d9ed6de13bc43349b52e1f705"

    # add back `--version` command, see discussions in https://github.com/0ldsk00l/nestopia/issues/430
    patch do
      url "https://github.com/0ldsk00l/nestopia/commit/76c5d0cdb75444c54258a184eb7a488b8f1dd4ec.patch?full_index=1"
      sha256 "4f1ad461502fe837261860690ab936a642925299054b0e8fe4b0b3e1a243e9e7"
    end
  end

  bottle do
    sha256 arm64_sequoia: "a0bdb08096a005edbb35f9807d2b834e9a8f79811c75b473d5584e0bf4efdcdc"
    sha256 arm64_sonoma:  "68e0b4795fc64dbf8158146a5f7fd96a99bb057ce06444c72dd8d1b275f25dc5"
    sha256 arm64_ventura: "8f2025bd929b74f756227cd72beef6fd04c12f0f17aa2f9987b475cc55ee161f"
    sha256 sonoma:        "e92205869fe6d03479e708ecdd00a05ab9799552195ce9aff49e25668c328418"
    sha256 ventura:       "f885dc6e40568171755c0b7b12b808b1fe051ecc12682dbd5fa8d9e7c7ab9aa2"
    sha256 x86_64_linux:  "cdede8ff541df4b2f4d553e7d99043ac1a35e4e403e9286cc6bb80cb22dd1fb8"
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
