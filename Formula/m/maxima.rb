class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.48.1-source/maxima-5.48.1.tar.gz"
  sha256 "b0916b5fb37b6eeaae400083175e68e28f80b9a1ab580c106a05448cf1c496b2"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdacb8e24fa51b08346624bfeb61daeed1c53e6002123149bb0e57d2ce402957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8acac49c95bfa70303d186704334bcf2c33bcbed683435f2cbcecc37d61a4bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065a0b9fbf8084faec9c0d133fd35c1b6d14c155ac9e00669d480791980fabe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6acfe9f56b9aa8ea86ad9159da8fa90d8beb1506c05550dba9258088b4a79b8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa1c77a0802adce5063ef2a8453af00004ac2fdd611100fc097ea8473a2223e5"
    sha256 cellar: :any_skip_relocation, ventura:       "6cdd2c68106eaafb6a254d7c6edff02b70742c7ce716a49804d02a339c0e1ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7dbb42aa2b0ce062d170200857af5999344dafe02f9beabbe2d17141caed4e3"
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
