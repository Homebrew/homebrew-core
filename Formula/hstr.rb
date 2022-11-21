class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/2.5.tar.gz"
  sha256 "7f5933fc07d55d09d5f7f9a6fbfdfc556d8a7d8575c3890ac1e672adabd2bec4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2577478a3850e2e11c3181c3e71e3b201d5ccd60efd2cf8de26efae4153607d9"
    sha256 cellar: :any,                 arm64_monterey: "bdb7df0cde335ab4ff34ff96a84dde6ef39141e9e1e78570b66a2f85696b67c9"
    sha256 cellar: :any,                 arm64_big_sur:  "64d0b3fa9b402b79747f2f4551d1a0fb194fe442bdf28c457c5bc67304c7278d"
    sha256 cellar: :any,                 ventura:        "6b7319ec2a3ba2b7037d3f4f205da1c050a0beaa40accd7b42af9f8454779252"
    sha256 cellar: :any,                 monterey:       "8cbf171433521bd0e4ca9b0523397a411301b33ae31d86ea16ee79f385448b8f"
    sha256 cellar: :any,                 big_sur:        "42756cb38b429efb90b340ac6574d51a2846aef73b35fa7037298cad436ff05d"
    sha256 cellar: :any,                 catalina:       "d16a1175f61a6e533c6b2717c03a5b2cd401d374c4482aee7dc5173e598be838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d4361666421b2a865c23bd37b386eccd4c5f0052923c534b6c8435b1a9dc8f"
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
