class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://www.bastoul.net/cloog/"
  url "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  revision 4

  livecheck do
    url "http://www.bastoul.net/cloog/download.php"
    regex(/href=.*?cloog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7e5820ebe53dcad85cc6cf960e5d645f2517a58d7869b573a884939ad995d51e"
    sha256 cellar: :any,                 arm64_big_sur:  "e5ee84fdfaf5d6fd364c471d3b9093695b6e89dcb75fe46781b4d5c7ffa054b3"
    sha256 cellar: :any,                 monterey:       "b93651ed59583b5ddaee5ab656942c03dff0423b5f5c150edb2421ce506cc4b9"
    sha256 cellar: :any,                 big_sur:        "92e11cfb0e13ea056e037c3283cc41df3e89eb9f667868c6e2f03bdce52a9044"
    sha256 cellar: :any,                 catalina:       "fda6ba25882ec08670819d042bbdd437266c968f18ce9a82effb944ca322664b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd6ad87a11d5161bc19777a133f8b22286ee2df3c4e7c7b48da7ae18b98bd9b1"
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl@0.18"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-isl=system",
                          "--with-isl-prefix=#{Formula["isl@0.18"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cloog").write <<~EOS
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    assert_match %r{Generated from #{testpath}/test.cloog by CLooG},
                 shell_output("#{bin}/cloog #{testpath}/test.cloog")
  end
end
