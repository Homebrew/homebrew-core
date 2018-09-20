class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.4.2.tar.bz2"
  sha256 "82f38750248c007956c38ffefcc549932c8b257b76c72fb79a06eabc50107369"

  bottle do
    cellar :any_skip_relocation
    sha256 "a04c09f5f16e79b77edcf6385658ee28ae8d4187abe10d937acc2e31de33d83f" => :mojave
    sha256 "f6f6896bcffcedd91647cf06bd924b1a08be6e6654f7a0cba7d1f471744f217c" => :high_sierra
    sha256 "f6f6896bcffcedd91647cf06bd924b1a08be6e6654f7a0cba7d1f471744f217c" => :sierra
    sha256 "f6f6896bcffcedd91647cf06bd924b1a08be6e6654f7a0cba7d1f471744f217c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "boost"
  needs :cxx11

  def install
    # Gets it to work when the CLT is installed
    inreplace "configure.ac", "$CPPFLAGS -I/usr/include -I/usr/local/include",
                              "$CPPFLAGS -I/usr/local/include"
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
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
