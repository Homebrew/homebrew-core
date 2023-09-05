class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/dejagnu/dejagnu-1.6.3.tar.gz"
  sha256 "87daefacd7958b4a69f88c6856dbd1634261963c414079d0c371f589cd66a2e3"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aae2cc17f126ef380eadd7d9a4909320f38d3b62c5722a2f9a777090cfe61720"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae2cc17f126ef380eadd7d9a4909320f38d3b62c5722a2f9a777090cfe61720"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aae2cc17f126ef380eadd7d9a4909320f38d3b62c5722a2f9a777090cfe61720"
    sha256 cellar: :any_skip_relocation, ventura:        "0369e312459148a10582a3d6f100167b44a80cfec0f03223099ecdaab7097551"
    sha256 cellar: :any_skip_relocation, monterey:       "0369e312459148a10582a3d6f100167b44a80cfec0f03223099ecdaab7097551"
    sha256 cellar: :any_skip_relocation, big_sur:        "0369e312459148a10582a3d6f100167b44a80cfec0f03223099ecdaab7097551"
    sha256 cellar: :any_skip_relocation, catalina:       "0369e312459148a10582a3d6f100167b44a80cfec0f03223099ecdaab7097551"
    sha256 cellar: :any_skip_relocation, mojave:         "0369e312459148a10582a3d6f100167b44a80cfec0f03223099ecdaab7097551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aae2cc17f126ef380eadd7d9a4909320f38d3b62c5722a2f9a777090cfe61720"
  end

  head do
    url "https://git.savannah.gnu.org/git/dejagnu.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "expect"

  def install
    ENV.deparallelize # Or fails on Mac Pro
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    # DejaGnu has no compiled code, so go directly to "make check"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/runtest"
  end
end
