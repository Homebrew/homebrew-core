class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 4

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82245da41cdcdb0c41187520638fda635d1f112b38dec9496d4321141ff5155f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8aa105d0535eb1bfbc62f4819dba80883b8bdab90f99e4c0bb05bcc9e64e99b7"
    sha256 cellar: :any_skip_relocation, monterey:       "b34e533fa6acbfb6f82778583952c2b9f7524860e3647bbc0c1c5b809edadf55"
    sha256 cellar: :any_skip_relocation, big_sur:        "c404ae11377eae562de509e17199610ccc236fe223d97b02744ac9cb2c0653ea"
    sha256 cellar: :any_skip_relocation, catalina:       "8b183f03af4e366124b1a91a8aa61a899f44ea473c16318c03d8962942bfaeaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5add87906b254ef2d53bafd4de250f7ec891e3a5702a4eecedd742970a8b84f"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--enable-gettext",
           "--enable-sbcl",
           "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
           "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
