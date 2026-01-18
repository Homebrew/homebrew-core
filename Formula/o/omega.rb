class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.30/xapian-omega-1.4.30.tar.xz"
  sha256 "b3faf202efd11ab6eb749bdd47f639b3dedc781eb0d579edafc80cd1340a461d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7aa6af0cfb692a25f14504b9e8f5e69654b3a691062fbaa037d1a8c6cd8ea046"
    sha256 arm64_sequoia: "873754a7c8613e0e08bdcab01c073da2f315e6261ca954e35ce28c07f6501d56"
    sha256 arm64_sonoma:  "dc6cbb76c35f2c43f313464c99a44e37ffecfc5356688b985bed86d8222596fb"
    sha256 sonoma:        "71b0d508818d4988be38202ea2c02b3c35a2ae33a7776542e73b06e2b6dc518b"
    sha256 arm64_linux:   "adea94d92b0dac8f962d4e16b9397a4a53c6417966a1c13d561e258a9d44e7ca"
    sha256 x86_64_linux:  "6963d3aa476e5656db149aa9c9b74cc68a9ef286be161c0cf9ce460ab706917c"
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
