class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.27/xapian-omega-1.4.27.tar.xz"
  sha256 "1d193b3285ec150557257b049ee1d8c94c40bcde906ce0ba7f1a38a1a9a5a5c1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "52ad2a9eb3d78d3025123d4d9cd5dbc4dd3007dbd95e5b36657cf5ccb420d849"
    sha256 arm64_sonoma:  "02dd50fcb859e119737d2d992fb055fd83a7edde194a5cd5778b84beed465861"
    sha256 arm64_ventura: "be25156706f01b6dbad1d8d2840558f700a840c4258b96c80f9711a72f542bde"
    sha256 sonoma:        "91d06380b0e7325318f851da456247bfe79e9dfae9cc0fba39c0b717926e7330"
    sha256 ventura:       "7c6282f0ea01a3af2933e90272e910479552d139658277b8aeb2993cf9644380"
    sha256 x86_64_linux:  "f46bac4544451f7403feff746e53d37f6ec5dcf67d7a2a9545bd2958058547ae"
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
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
