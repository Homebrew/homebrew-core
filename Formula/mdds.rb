class Mdds < Formula
  desc "multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "http://kohei.us/files/mdds/src/mdds-1.2.2.tar.bz2"
  sha256 "141e730b39110434b02cd844c5ad3442103f7c35f7e9a4d6a9f8af813594cc9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "47a1316524f2717d7dbac84c1c060dac8e2297ef61dd86e9350d202e30f19a74" => :el_capitan
    sha256 "e03dfcf7ba2f4d84226b8cb53745d7aa52d5413ce3f55e937b42975bc475bbee" => :yosemite
    sha256 "defd1f5bddfd8666b53e295e98f7d184005230adec3e6cd67ff964217eca36eb" => :mavericks
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
    (testpath/"test.cpp").write <<-EOS.undent
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
