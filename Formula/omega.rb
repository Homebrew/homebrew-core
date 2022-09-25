class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.21/xapian-omega-1.4.21.tar.xz"
  sha256 "88a113c5598fc95833e1212c70be463abb9d5601564d21b861636f737955aad5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f31fc4528304c469409597cc3e5020ca3b64d18df7b9d478423c2d722a3cb7f4"
    sha256 arm64_big_sur:  "d528b1f8c49977851c96018a85fcabb6123a02295e6ffd78f178a4e954032b15"
    sha256 monterey:       "24aa73ee85c48d037cd4e89372c1b3a77d29dd0751e5bec17f3735833c2ab09c"
    sha256 big_sur:        "4825314fe767f36588ed224150bb35fbe97dc11fe8f3d51404443b27a09c6677"
    sha256 catalina:       "355a1633fb902636576152608fa9bc78fea0571ba5c7049d9c4d953f29bb95a4"
    sha256 x86_64_linux:   "280e98c2623fa1636caf48a11a58ee15a07885ffec9f310153daf82283754277"
  end

  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "pcre2"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
