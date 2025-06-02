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
    sha256 arm64_sequoia: "9872cd039fdb166ea6e2725bc555a0d4a810abfc455a5f295e94dfa50a82e1a4"
    sha256 arm64_sonoma:  "2c2ce6e31a93ef3ab2a346675d1afe9243ec606bc448b3d3e9b2d7c0849b05ae"
    sha256 arm64_ventura: "ceda263ce18b87eea2430765bfa2eeebb905ab8b67a8ab63ad81178c0787cb49"
    sha256 sonoma:        "801e64be4f8663f856b9b2716ed3c4428dce9dbba21983650017cea9a011f88e"
    sha256 ventura:       "8984d07d97d61fb6e211c3cca3fec3f649cbefa6f01effc63a0ee9239084a8cd"
    sha256 arm64_linux:   "577c8aace1e6aa8595bf462ea0f58ab26ac2bcc0264d3eedaa793b92bc1bc38f"
    sha256 x86_64_linux:  "ddf2a15db4c87fb65d1e39c01cd07a361b2e4c3f8345c17dcb62a2869f3b3ad1"
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
