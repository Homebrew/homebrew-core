class Jbigkit < Formula
  desc "JBIG1 data compression standard implementation"
  homepage "https://www.cl.cam.ac.uk/~mgk25/jbigkit/"
  url "https://www.cl.cam.ac.uk/~mgk25/jbigkit/download/jbigkit-2.2.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/j/jbigkit/jbigkit_2.2.orig.tar.gz"
  sha256 "3302109c93b7befbffa3cfe8bceb4355f19dea0ee7dcb5f33710b1648bf6645c"
  license "GPL-2.0-or-later"
  head "https://www.cl.cam.ac.uk/~mgk25/git/jbigkit", using: :git, branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?jbigkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38c8780667bfd91321c0523ced2515894d43907374103940ca60465d67d80748"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7607ddffbce1b972049f6825e34a887fcc01ac08ac075cbc22b5851a9650902c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9be34cc09553cb7ad2103b18140bfcc82c6a9143ecc3ad6c8141f0fdc6789d1f"
    sha256 cellar: :any,                 arm64_linux:       "1e65dbd99b20a03c02096fe73149ccb4ec31a01b34e6c39cdc7a628be276d605"
    sha256 cellar: :any,                 x86_64_linux:      "5d2f6fc8e42aa3d77b94c8f428438785c38b30b1adcba8ba4da668c6b91eac4e"
  end

  conflicts_with "netpbm", because: "both install `pbm.5` and `pgm.5` files"

  deny_network_access!

  def install
    system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}"

    cd "pbmtools" do
      bin.install %w[pbmtojbg jbgtopbm pbmtojbg85 jbgtopbm85]
      man1.install %w[pbmtojbg.1 jbgtopbm.1]
      man5.install %w[pbm.5 pgm.5]
    end
    cd "libjbig" do
      lib.install Dir["lib*.a"]
      (prefix/"src").install Dir["j*.c", "j*.txt"]
      include.install Dir["j*.h"]
    end
    pkgshare.install "examples"
  end

  test do
    system "#{bin}/jbgtopbm #{pkgshare}/examples/ccitt7.jbg | #{bin}/pbmtojbg - testoutput.jbg"
    system "/usr/bin/cmp", pkgshare/"examples/ccitt7.jbg", "testoutput.jbg"
  end
end
