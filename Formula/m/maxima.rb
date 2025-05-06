class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 21

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c06983e9d021a124550f5615ebda6601c4f0c3a68cad65fdfd9eef19155e0b1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f17bae77e9e2ffc4006cfbfe373f45c5be77502ef291b9408d1b9ddbccec407"
    sha256 cellar: :any_skip_relocation, sonoma:        "b321b497346ba5a245b324934c85eed5e9b1836aed2349944044a27571fb94c3"
    sha256 cellar: :any_skip_relocation, ventura:       "9be3c5c7129f9e483b44d06a1f1b1826e21e316803945670ea7556f6705e57ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781e89cc152c5f13223bfc7442df7a277a2e3f06d5e17ee3a754262f1e3f50df"
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
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end
