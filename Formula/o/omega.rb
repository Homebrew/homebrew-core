class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.29/xapian-omega-1.4.29.tar.xz"
  sha256 "4fba4e9d496b4e4dba0a409ce2342e5958a69c6ab3e60ee4dda25be5c20cf83e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1c3bd76d786b6577aa804469d71b594c060a208916260a334559c884b95b8938"
    sha256 arm64_sonoma:  "869b6b4421188bf67500e0a00b864d5dfadd648b3ba4c83c113ffa221b732fbe"
    sha256 arm64_ventura: "fb00ac087a36daaf9a1afe13c7d40a902d9c6e0e6bf506230f9a0c588097de8e"
    sha256 sonoma:        "9e2310fbb0e513a53980330204064f76707560d6c4221112850549cdc8144f84"
    sha256 ventura:       "0f1e50a95b70fa8ef243f3fd687f990fc596b0b87798b2c35187a2efccd5a23b"
    sha256 arm64_linux:   "8afb5342b53119433533769a458eda11deab883f1392178806fd4a1671e7400b"
    sha256 x86_64_linux:  "559e6d9e2fb79358a3ca6d464a3e4376c32794a2c085e858123cd5f394d209a7"
  end

  depends_on "pkgconf" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "xapian"

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"omindex", "--db", "./test", "--url", "/", share/"doc/xapian-omega"
    assert_path_exists testpath/"./test/flintlock"
  end
end
