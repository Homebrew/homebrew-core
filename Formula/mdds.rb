class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.3.1.tar.bz2"
  sha256 "dcb8cd2425567a5a5ec164afea475bce57784bca3e352ad4cbdd3d1a7e08e5a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a1f26a51dbd73b634db0a3ec72d80758e0b1b94a50908bace789eb8994b9d87" => :high_sierra
    sha256 "5a1f26a51dbd73b634db0a3ec72d80758e0b1b94a50908bace789eb8994b9d87" => :sierra
    sha256 "5a1f26a51dbd73b634db0a3ec72d80758e0b1b94a50908bace789eb8994b9d87" => :el_capitan
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
