class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/1.21.tar.gz"
  sha256 "f0e9762f2a9587f0995bbd51cb64526ae852c2425ceb8ceee0747efba80ac6b3"
  head "https://github.com/dvorka/hstr.git"

  bottle do
    cellar :any
    sha256 "19610c8ddce3e6f00bd274dd668f6e026b8449c72be593b5e1b59f5250b35c42" => :sierra
    sha256 "ec9c8e76d52b0293efe225d3ac9312e2edec14e7c9c84c6b8140fec8300f806b" => :el_capitan
    sha256 "ee3ece1e2ce9794d6e68f5f2a5749753e1fe4f4512de50b0397e4865ccbe81d1" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_equal "test", shell_output("#{bin}/hh -n").chomp
  end
end
