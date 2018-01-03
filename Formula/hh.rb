class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/1.24.tar.gz"
  sha256 "6c130afd8ca570ee1988a0c7d6a96efeeabd21be7e05ce1f3144bb3c86c74441"
  head "https://github.com/dvorka/hstr.git"

  bottle do
    cellar :any
    sha256 "3806e269c5d29b06e157cb9aa9675cf5c9bda57a8546965de54d0a1da0aa93b6" => :high_sierra
    sha256 "863eed15e12bafbe8023ef3d1a40ea2f8abcbbec03e2c09113b7cc7c63848e9b" => :sierra
    sha256 "e8105d2183a21e922bd904d5af25eac6d123e5c2ccc8f9fa8a363af1aedd2510" => :el_capitan
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
