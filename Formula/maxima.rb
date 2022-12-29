class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 8

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61ba66f0e484b4aaa1115bd28188c64e2eab6827530b0927aeaf47bff1e31a6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b56557a4d3a27cceb548fa4341885fb15c28c9df21987a2e8ae8b81495309720"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85b39fa1a991853758490bbbe500b94a243145bd14e87a8aaac64e73f45272e1"
    sha256 cellar: :any_skip_relocation, ventura:        "483fbe0a31d79ee37da05e597a5c97d177b377f5d6fa1e304b089b2277f69f93"
    sha256 cellar: :any_skip_relocation, monterey:       "e8112c54d0f612c0a406b15e32a25e6bb14aa5fa209383822cc69da24b9e722b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c800d29837cf469187752ddfa92c1bd4c5309c5b135c2a07d0283c0e46f47767"
    sha256 cellar: :any_skip_relocation, catalina:       "140e327eb5177416f846bd132435e5b294f75879cfed65acd7fa005b42312fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61246ba5d9498c1fab9f06b71c1b6ccc0d8ad2a13b6a3408053190f1e7b768b9"
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
