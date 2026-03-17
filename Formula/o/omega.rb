class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/2.0.0/xapian-omega-2.0.0.tar.xz"
  sha256 "85088a16cf64ea676d0856813244909f132e1b32013a56928c40a1e333a6734a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cee10369fe7fee6df22ca0aa69a14c71d4c8268b9bf71da6439f663929dd635d"
    sha256 arm64_sequoia: "218d20322c0ff49d314d37565d9e313fd7fb5dc8993ef83aca107976a486647c"
    sha256 arm64_sonoma:  "35f5fc8ab55e384a088f46880d43b920e21f344902861fa96ee70b7de8bd18ff"
    sha256 sonoma:        "2e86d65f179c025508632fea7a415bfa07283748e9bb0efb1e2f2909e431d7d2"
    sha256 arm64_linux:   "9eeef925be6b3e3406591605fc0d230a1314be3bfa74f62061003fa4d13e4430"
    sha256 x86_64_linux:  "29f27f623abb65bcbe5a2715cb6e9d2a21b802df6e58bf7bcc5f92d797caf02a"
  end

  depends_on "pkgconf" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "xapian"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"omindex", "--db", "./test", "--url", "/", share/"doc/xapian-omega"
    assert_path_exists testpath/"./test/flintlock"
  end
end
