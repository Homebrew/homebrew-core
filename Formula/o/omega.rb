class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.23/xapian-omega-1.4.23.tar.xz"
  sha256 "7ba460eba70004d1f44299de4e62dcc84009927e6d52604ae67a3e30165e220f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-omega[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0a13623db696c4db8d4c065c03e17f5823051efb2a856b77fb77bc8815dc669b"
    sha256 arm64_monterey: "6d3beb88a06c75243dc6a93f792f9ca5b87692c7bcf5e4c788cb9257d107dff9"
    sha256 arm64_big_sur:  "d0afcd8dd26c10291fb79d2d13b6fc0b5e9c0d5da1353a454178cb64284f46d9"
    sha256 ventura:        "4e3cae57c971d47cd3db6ce26bd48bba790e0917de97aad48d9876cbdab17be6"
    sha256 monterey:       "cac82638593943c7b633d261f5ff598a715cfcca6dd86a887e774c5985e92a43"
    sha256 big_sur:        "f10ec494d78a3e0cae7ba7107ae4bd9016b08e7c647a1baa6d98b7693993a044"
    sha256 x86_64_linux:   "cbe07c89f37a2045ec9ba8e15498e8f8b1a05e0f9b5d0249d01dc77b56fcf874"
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
