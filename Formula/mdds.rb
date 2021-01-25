class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.7.0.tar.bz2"
  sha256 "a66a2a8293a3abc6cd9baff7c236156e2666935cbfb69a15d64d38141638fecf"
  license "MIT"

  livecheck do
    url :head
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "59ebe66bdf74479076e8df76ba906f2bda539f819c778abaf608acbae04343f3" => :big_sur
    sha256 "f4c421f18efdd519f3ca12a78295c2b1c5e36f6726369736e68ed07870e40a33" => :arm64_big_sur
    sha256 "a5e6a996bf112bca0d5c7e628fd15128977b9075938155a4185aaf5613d136bc" => :catalina
    sha256 "5146b50529f63030c978dbdab3755ce7a7383d7c8049e03ae1186fa231f867c9" => :mojave
    sha256 "67f497efa10f695da64e4769d3ef5de6fb0e9d3d0d62026c2105b7c5148b91a9" => :high_sierra
  end

  head do
    url "https://gitlab.com/mdds/mdds.git"

    depends_on "automake" => :build
  end

  depends_on "autoconf" => :build
  depends_on "boost"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-openmp
    ]

    # Gets it to work when the CLT is installed
    inreplace "configure.ac", "$CPPFLAGS -I/usr/include -I/usr/local/include",
                              "$CPPFLAGS -I/usr/local/include"

    if build.head?
      system "./autogen.sh", *args
    else
      system "autoconf"
      system "./configure", *args
    end

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
