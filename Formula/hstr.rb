class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/2.2.tar.gz"
  sha256 "886531ca9d8d1a5a93a3db96e9fc64154a03f6de428c74c722b41057bceca266"

  bottle do
    cellar :any
    sha256 "5b3c9395c5d63b3a75bad4ef78ec8eb7d1e359fd72904feab750bf9d162f44ec" => :catalina
    sha256 "99916c805fb5e557e366c1c0cff89d160148607f0a401084fd555c4ba6619c4d" => :mojave
    sha256 "a8477c9cd9c66f9d9045328615941f0d1366441cf282c2011f71c4f7061302ba" => :high_sierra
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
