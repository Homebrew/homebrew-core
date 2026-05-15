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
    sha256 arm64_tahoe:   "f469ef4f1a35d66c86dd5401631664df649e057df44aee40bc53f7f9024dcf33"
    sha256 arm64_sequoia: "978bbca4afa94cefd5dae18b458b1f7377f18de57caa9f8370c8d147cf643217"
    sha256 arm64_sonoma:  "fee41f0cf3f0cfd8d7083dd8ebbba410eb84ce7ba10aff931b96f0f28b12cbb4"
    sha256 sonoma:        "bdcff8da23e5990b3c4b7b905046a1f28585bc966c3946d657519edfb2a872f1"
    sha256 arm64_linux:   "d978d3f8de65bfb035c10d404b4efbc396924260d12c0ff58921ed9793df9c78"
    sha256 x86_64_linux:  "5573c8debb295912076631fc4320988fb1c1802286899bab9cb8d47495fddc05"
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
