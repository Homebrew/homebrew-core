class Jellyfish < Formula
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.3.0/jellyfish-2.3.0.tar.gz"
  sha256 "e195b7cf7ba42a90e5e112c0ed27894cd7ac864476dc5fb45ab169f5b930ea5a"
  license any_of: ["BSD-3-Clause", "GPL-3.0-or-later"]

  depends_on "autoconf@2.69" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib"

  def install
    # autoreconf to fix flat namespace detection bug.
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.fa").write <<~EOS
      >Homebrew
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system "#{bin}/jellyfish", "count", "-m17", "-s100M", "-t2", "-C", "test.fa"
    assert_match "1 54", shell_output("#{bin}/jellyfish histo mer_counts.jf")
    assert_match(/Unique:\s+54/, shell_output("#{bin}/jellyfish stats mer_counts.jf"))
  end
end
