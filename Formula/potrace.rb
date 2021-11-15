class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "https://potrace.sourceforge.io/"
  url "https://potrace.sourceforge.io/download/1.16/potrace-1.16.tar.gz"
  sha256 "be8248a17dedd6ccbaab2fcc45835bb0502d062e40fbded3bc56028ce5eb7acc"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://potrace.sourceforge.net/"
    strategy :page_match
    regex(/href=.*?potrace[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cc774c2a6d82a036c9ccf80ed467aabbf39697e8a36ef210cb5b793fb4b6be05"
    sha256 cellar: :any,                 arm64_big_sur:  "80d3d0256f9b7add7d3835f6c84f30afec6a4893f2fcd2aa44b07ebe95876c7f"
    sha256 cellar: :any,                 monterey:       "2e65796f5e50c82a6b11475034b04f6a0647f044c5c81a819bb6b3e8f0d5e6cc"
    sha256 cellar: :any,                 big_sur:        "3b5294deed86179a4e496236fb882eb0b7ad3c020741e2a1398861b545062712"
    sha256 cellar: :any,                 catalina:       "c3f357a8bd6460384400acd00dab0d8571ad0b1543a81e5b9d5ff49d1ece4fa1"
    sha256 cellar: :any,                 mojave:         "3ad69cce4edecea6e5170b766201845b703a98bbac3c5272ef6a045f828643e2"
    sha256 cellar: :any,                 high_sierra:    "56d821a4d3579bedf64ebf5357fc04f214cb2efbea7ddb681b202e684e71d97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47c98611b15465f29e55972018135927d42929e5901153ad99c6579de32863c"
  end

  uses_from_macos "zlib"

  resource "head.pbm" do
    url "https://potrace.sourceforge.io/img/head.pbm"
    sha256 "3c8dd6643b43cf006b30a7a5ee9604efab82faa40ac7fbf31d8b907b8814814f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make", "install"
  end

  test do
    resource("head.pbm").stage testpath
    system "#{bin}/potrace", "-o", "test.eps", "head.pbm"
    assert_predicate testpath/"test.eps", :exist?
  end
end
