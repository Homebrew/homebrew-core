class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/1.23.tar.gz"
  sha256 "f435b4fce473e966fe52d3c27ca9074df0925a236b01517ece022607b889af33"
  head "https://github.com/dvorka/hstr.git"

  bottle do
    cellar :any
    sha256 "53f1394c25ec70f3b36cfab592cae961d4f88fcff2a95726c716e84b6fbc47f1" => :sierra
    sha256 "7c6f3bfbf05d62f769b343f8d2172dc9f1d713af9ca1766183d81e34ab494f84" => :el_capitan
    sha256 "b51559f5d0d5791e356b85a1a98a8d287180d7931a21595375620ad70222d742" => :yosemite
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
