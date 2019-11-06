class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/2.0.tar.gz"
  sha256 "8d93ed8bfee1a979e8d06646e162b70316e2097e16243636d81011ba1000627a"
  revision 1

  bottle do
    cellar :any
    sha256 "6c96df4e668d1cebcd34b521ff1c3a239faa1e0ec4725824e2b3d3a0fbde9e6b" => :catalina
    sha256 "6bc65753efae0a89c2b9828e37928a879cd56884a03b0b1bbf34e8056590efc0" => :mojave
    sha256 "8674fdfe45a193a76a7c67ef4e7df70c08ccca8ab60194acc67be2622bfeed15" => :high_sierra
    sha256 "855047dba9374bce6e7d880aa7847a77a4429d86ad611992c4f94ad207d0d11b" => :sierra
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
