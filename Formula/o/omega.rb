class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.26/xapian-omega-1.4.26.tar.xz"
  sha256 "a5b2386e1b04df84d1149a9e9c5bcfc5e4726a69a69da641b86c68d79967dae4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "b3dc3285f23afa9b07481e9f1e92914e248db29a9336bf69a6d9b9a4ebaa5a01"
    sha256 arm64_sonoma:   "caedc24dd693d1375fc62fda463055d5e65482760170f9f7872d4dc9be7c82db"
    sha256 arm64_ventura:  "4bcee3d5ac1960b6dd54e564886c2fa0235d1f06dce0f603041e86b370a7653c"
    sha256 arm64_monterey: "5c13bd254c537f35dc21bd7ef2bebbbc687e43110ac252a0851403591b9ee0f7"
    sha256 sonoma:         "39b00ec930aef79e7d886efdf1b94616c393d2accee31f1ef09a65fc53cef914"
    sha256 ventura:        "58dc62467f3385fc5098d6cbb76d1cd5354242662643ca47b0e69ae5a9167e9d"
    sha256 monterey:       "404b0f3b269f1327267ace1688a6399b88914d3a60594b6d3b5bb9d945762e14"
    sha256 x86_64_linux:   "8c5d3d4f9b8456a19cff0b0d47f3662734cac29a69a07ece8bdc840fd5a6b253"
  end

  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "xapian"

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"omindex", "--db", "./test", "--url", "/", share/"doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
