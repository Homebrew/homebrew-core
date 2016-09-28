class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.19/hh-1.19-src.tgz"
  sha256 "b67cb5e2515948fd0fb402b732630a51885be5dfe58cbf914c22ea444129a647"
  revision 1

  bottle do
    cellar :any
    sha256 "19610c8ddce3e6f00bd274dd668f6e026b8449c72be593b5e1b59f5250b35c42" => :sierra
    sha256 "ec9c8e76d52b0293efe225d3ac9312e2edec14e7c9c84c6b8140fec8300f806b" => :el_capitan
    sha256 "ee3ece1e2ce9794d6e68f5f2a5749753e1fe4f4512de50b0397e4865ccbe81d1" => :yosemite
  end

  head do
    url "https://github.com/dvorka/hstr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "readline"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/".hh_test"
    path.write "test\n"
    ENV["HISTFILE"] = path
    assert_equal "test\n", `#{bin}/hh -n`
  end
end
