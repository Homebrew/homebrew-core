class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.25/xapian-omega-1.4.25.tar.xz"
  sha256 "2fc0b505e606d5e1dcde1f22362b6f0237d9e847fc9b6af538f99bc9abd1fccb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6c382c25807c5c7988be7cfa0b805611917fcf5422fdd1b030313b235597af57"
    sha256 arm64_ventura:  "6812f64288e8adf48cdce414cbc0ad884d6b2cf4dd1039a25ea1768ea3f7c863"
    sha256 arm64_monterey: "53ddd62ae301bb2bbdb7bf398213362438ceed13879841d2183ec44149e4fc62"
    sha256 sonoma:         "9f590bba4f0b97f7c433a51eb0562054f841c226fe71cc0c1f1ffcf68df25e95"
    sha256 ventura:        "431f55d7584b994e16ae4c25610fc9274597381c1ac1ef9bdb3e5ef422a4e13a"
    sha256 monterey:       "c45a4ed18d50c4592e6229c34b7de6d95eaaf277ed4b42a451038b12c3d6aa20"
    sha256 x86_64_linux:   "40803f181f1f6c429aaec0f7d80057a061a692bba40c34c18c045ba9f9194e73"
  end

  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "xapian"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"omindex", "--db", "./test", "--url", "/", share/"doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
