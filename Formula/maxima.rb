class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f10ca28d61f041e718581050dde24aea407cfc90ec77bd5cdab376537f1f9bc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3ec53f9bbbae8922ec84cc5e44905f7f1fc952fe2570976172d8aedbd8aa3c1"
    sha256 cellar: :any_skip_relocation, monterey:       "c1bd4ce41a16ee92682b06bfdfd7470cc7320cedc308e167b2d7e2882eb16bd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d0bd876d8ad2b828f60b0718b77d80b7640d793e9015dc908f8cebb44aca9ca"
    sha256 cellar: :any_skip_relocation, catalina:       "f74f9bb98d30654904fd5a72ba4105a61f443cb1ec2fcc9fa7765e68e85b4baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f64ec75a642dc9b3bb9558ad8c66084a6a8559c14b08b99655ea4156c611e1b2"
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
