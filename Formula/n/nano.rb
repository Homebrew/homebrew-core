class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v8/nano-8.3.tar.xz"
  sha256 "551b717b2e28f7e90f749323686a1b5bbbd84cfa1390604d854a3ca3778f111e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "f2858bef24029c87c86219ad7b15858a96c4f33083e8e22ee8702e01a93f2cd6"
    sha256 arm64_sonoma:   "1dc026c641f6050f2427e6ee8e2870704a77c21faf9d0a4fe769f35f9f17160f"
    sha256 arm64_ventura:  "51eb77fc2f324e342389f58d097192d04b583b43df733544c0204dacc29314d8"
    sha256 arm64_monterey: "5ab2b245c967d15816675f2e7029b0385894a4e794d96980f685068268a6f30e"
    sha256 sonoma:         "582eccd6c4fd5e00c6e717501c86193fae2ccc930c34200267a2783a8c61f0f3"
    sha256 ventura:        "00a0221f0ab8d70a97bcbc93e0cb4bc78c236add72bc2cd48382262e5e2cfba1"
    sha256 monterey:       "d172322c6a4d5b50a050e5cf9499229efd3a187f2d8a30c296cc6aeef191b562"
    sha256 x86_64_linux:   "edf58c3490cd237a93a008057d5e434aa89be53065bafd94b1a64f1dd17018eb"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "ncurses"

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "./configure", "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system bin/"nano", "--version"
  end
end
