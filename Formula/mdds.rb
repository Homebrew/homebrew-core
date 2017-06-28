class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.2.2.tar.bz2"
  sha256 "141e730b39110434b02cd844c5ad3442103f7c35f7e9a4d6a9f8af813594cc9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f91e37bf2763a0290807e0e8034db690695b0a60611665dc844bf2a1352de73e" => :sierra
    sha256 "f91e37bf2763a0290807e0e8034db690695b0a60611665dc844bf2a1352de73e" => :el_capitan
    sha256 "f91e37bf2763a0290807e0e8034db690695b0a60611665dc844bf2a1352de73e" => :yosemite
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
