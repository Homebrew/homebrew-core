class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.6.0.tar.bz2"
  sha256 "f1585c9cbd12f83a6d43d395ac1ab6a9d9d5d77f062c7b5f704e24ed72dae07d"

  bottle do
    cellar :any_skip_relocation
    sha256 "b99d97a6301b18f1abb2e8743115f099dc5ed753a5d44949affa083af3d1b0a1" => :catalina
    sha256 "b99d97a6301b18f1abb2e8743115f099dc5ed753a5d44949affa083af3d1b0a1" => :mojave
    sha256 "b99d97a6301b18f1abb2e8743115f099dc5ed753a5d44949affa083af3d1b0a1" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "boost"

  def install
    # Gets it to work when the CLT is installed
    inreplace "configure.ac", "$CPPFLAGS -I/usr/include -I/usr/local/include",
                              "$CPPFLAGS -I/usr/local/include"
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--disable-openmp"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mdds/flat_segment_tree.hpp>
      int main() {
        mdds::flat_segment_tree<unsigned, unsigned> fst(0, 4, 8);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++11",
                    "-I#{include.children.first}"
    system "./test"
  end
end
