class Jellyfish < Formula
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "https://github.com/gmarcais/Jellyfish"
  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.3.1/jellyfish-2.3.1.tar.gz"
  sha256 "ee032b57257948ca0f0610883099267572c91a635eecbd88ae5d8974c2430fcd"
  license any_of: ["BSD-3-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0417631105929539a2126368a9bc8128eaa1f97ad30819bfc9a9cb72e5313e28"
    sha256 cellar: :any,                 arm64_ventura:  "12d4462803ed8c86dde8eb3079fa40f0e921605f484317b2fdbb9ea01ba381c1"
    sha256 cellar: :any,                 arm64_monterey: "e348f51e3326d59d9944bcf7778c876d83aa4e6a5173a8f967e8284751bb5b31"
    sha256 cellar: :any,                 sonoma:         "5cea64914e0780caa84ed59a40def3e32711715e5459f4a49b29e9bdcdf374c4"
    sha256 cellar: :any,                 ventura:        "55f9ba9cc23d3f238d711973cad51e2db5e9805f2abb9b2c2016ecb183dfd55c"
    sha256 cellar: :any,                 monterey:       "ef1f0988a3d81bc9fe2179887d4b49b585f98fdaa130567626c594b3dc92c012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105fae95b5a56dea674d9e6f97e6dadde81372f86b3c3dc8303548460dfb376e"
  end

  depends_on "pkg-config" => :build
  depends_on "htslib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
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
