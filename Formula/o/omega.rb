class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/2.1.0/xapian-omega-2.1.0.tar.xz"
  sha256 "e3bcf29b5fcb790c28c3e90624ff9297a9a44914f0ba566cb3ee677a015097be"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e2b3b52aaadba60e2d93d5427a041141e73374762561a71ffb8ec3a25f9d22af"
    sha256 arm64_sequoia: "8474283d13f96b17fa2c5bc4dad7f364328d5ff1bde47c31b07c3dde43d7038d"
    sha256 arm64_sonoma:  "80fcec8ed3585e07f75fc4d24cb1ef43c1e2b339f5df8a946b447dc88bf20f71"
    sha256 sonoma:        "59ca3d0da2e551b687ecc362f3098dff83edc6b9c92ffd3f905e9978e1a1587f"
    sha256 arm64_linux:   "75cd197eb8d2420c12e2f0dad8318f7e282da2b1d6b65703563bb2b467ec2fcd"
    sha256 x86_64_linux:  "4ee547af9b219fbee3571720d6ca51c57c821874ac47747f08102d3b3560d220"
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
