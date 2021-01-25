class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/2.3.tar.gz"
  sha256 "c7e7408671757b3f4be9c5a59b4e2d56e7a7b601ace2a94eb6b2b61f20ee890b"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "23a7e98369fa1ef412f6f374d24a1828b5131425b39b828688004cf6e4cedda8" => :big_sur
    sha256 "6f1758717c6c34317a775a0975864d66bdd2696f491859627a00641966ce6ece" => :arm64_big_sur
    sha256 "eb5a750b04ba6c1908bde96a1bd7fb8733a80632953eeb5d43ad51b7747cc191" => :catalina
    sha256 "723f7aec818080a72e40a3eda2aad8669d5d952927a7894718946cc0b788ff27" => :mojave
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
