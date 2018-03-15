class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/1.24.tar.gz"
  sha256 "6c130afd8ca570ee1988a0c7d6a96efeeabd21be7e05ce1f3144bb3c86c74441"
  head "https://github.com/dvorka/hstr.git"

  bottle do
    cellar :any
    sha256 "90be269fa8ed7ed3538f91d34cccc5fe87e4ce3e328b64a6c74f558d5f2d0633" => :high_sierra
    sha256 "3a194279a8c4eda33d00398e6c3a2a854c9c15194449d1d0e813e57b17993cae" => :sierra
    sha256 "4bbad864545de6e4f2a8e914fc20495983c0bde0feb2e2da9353a8169cfaa3fa" => :el_capitan
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
