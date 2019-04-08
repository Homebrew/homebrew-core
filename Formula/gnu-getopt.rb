class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.xz"
  sha256 "86e6707a379c7ff5489c218cfaf1e3464b0b95acf7817db0bc5f179e356a67b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "702e009224e60952ea5b673fabb9cb9e3c05ce5e7923a5485fd34bfc73542c88" => :mojave
    sha256 "54596caa40b03e440c44f3a0bd7475a5c3f2bee187feb825ec51ef59e9e00862" => :high_sierra
    sha256 "3339c54159a904d773848cbd8c33dd89ee3459db313b98ac4f33d258b4bb5ac5" => :sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
