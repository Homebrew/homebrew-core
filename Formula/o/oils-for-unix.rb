class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.37.0.tar.gz"
  sha256 "f4d41d20a0523dbcfbd4ba231f82edf25b08d4965d65bc71fcb56666d6743000"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78ad773133116d4f0552f7aee472eadaeb746242c18709af21f1174b56dbfe40"
    sha256 cellar: :any,                 arm64_sequoia: "9376c438f4cc76b588affa35c61f2be91729ff34ff213afdaf27e091ccebfd7f"
    sha256 cellar: :any,                 arm64_sonoma:  "1211e0bcdd6b6ccf0e16cfb310b40295f496e131374c390184aafef8c88bef48"
    sha256 cellar: :any,                 sonoma:        "21baa2abb4dead1655801f44a1ec764ba37c3dbc99ff0e3489affb94b711065d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96888e840150140c0101352d2f6aa8ba526b48cec35564555255edc65e36c57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b779dc36db8448f09582af439acb8b41e2d712dbb7ebbbc340526cb7c3f9131"
  end

  depends_on "readline"

  conflicts_with "oil", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{Formula["readline"].opt_prefix}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q lastpipe"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end
