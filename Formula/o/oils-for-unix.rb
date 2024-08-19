class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oils-for-unix-0.22.0.tar.gz"
  sha256 "7ad64ad951faa9b8fd310fc17df0a93291e041ab75311aca1bc85cbbfa7ad45f"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "52ae2b5e7abe69ca0f9960b0a77e079729161578ce874b2cf327a09d8058c7e9"
    sha256 cellar: :any,                 arm64_ventura:  "52f5d4e0ed390c42557419ffa92b7cb30bb4b78d87808a499f44d1993905caa4"
    sha256 cellar: :any,                 arm64_monterey: "f79f2c3b7a1173f135f72d6d2b43cc1b20f79543e7f460bfb69c140022d298f3"
    sha256 cellar: :any,                 sonoma:         "b545329dfb7aca7b9aa7546d64ec3705aa710e87bfcbd3bbe03201933ab7a091"
    sha256 cellar: :any,                 ventura:        "c6bc66b8d7dad9dc715c2d829926a010d6146a1b47fe7dc4665c136f7457c719"
    sha256 cellar: :any,                 monterey:       "ebfcaca05a8f8b90eb4c3f51f2fdac082dc8adcd475dc46846e1a55b1566bcb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a8f588f5a36d18210b4a5b12c3343ca234c96242076e588f071536f77306f0"
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
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end
