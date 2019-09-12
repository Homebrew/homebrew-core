class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.5.0.tar.bz2"
  sha256 "74cda018d5aa39a2f91652608efb066fd225f3597ce54733e6ab1e99e52606f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "365469df7544a2a76711ca2c41de5641774046c73ccd61f0f67c8377139e9140" => :mojave
    sha256 "365469df7544a2a76711ca2c41de5641774046c73ccd61f0f67c8377139e9140" => :high_sierra
    sha256 "040b58c48c4188f2985f4b10bfa0483b8ddfc666d98efe129744e5209faef7d7" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "boost"

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
