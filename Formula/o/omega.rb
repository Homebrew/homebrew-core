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
    sha256 arm64_sonoma:   "78053bee0bfaae7ca4b024ea2b2ba55beecdcab633301f2215e71b144ec347c3"
    sha256 arm64_ventura:  "13a27fb21c060e3affd40d2b33c2054b8a2cf7c196eeadd24ef0dc35381c5d51"
    sha256 arm64_monterey: "e98055a9f13a6aa1b2ef9a3d87929455fdb805510cea88aa854290965bfe63ed"
    sha256 sonoma:         "3df1c75bea66c589ade64758ffe254802d3598a871a41a77f365e782f7a994c7"
    sha256 ventura:        "b9dbeb020adf71ac697af7d3907a0bf89f0cf736dc2961d1da2bcc233193c085"
    sha256 monterey:       "1f8bb0bae492373d9a997439c0d514f83da354c11b5ef1a5193ec11ba979420c"
    sha256 x86_64_linux:   "88b0c2f104398f6d4947476b19240d5c45008440355da8e011ce79b86d617385"
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
