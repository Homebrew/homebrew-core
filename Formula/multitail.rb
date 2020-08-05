class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://vanheusden.com/multitail/multitail-6.5.0.tgz"
  sha256 "b29d5e77dfc663c7500f78da67de5d82d35d9417a4741a89a18ce9ee7bdba9ed"
  head "https://github.com/flok99/multitail.git"

  bottle do
    cellar :any
    sha256 "6d0d74b45d02adc52fa6a5f666484c62941457da3cb10e50d65f5d772cc59c02" => :catalina
    sha256 "933801e9ec5999742cfcea6cc59580f69fc966ad82858326c2a90f68868de60f" => :mojave
    sha256 "57526de43035b0d5d2520d54b252d29c20a4efb146c019ac044ad5067be5351a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
