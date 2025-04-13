class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-3.0.0.tar.bz2"
  sha256 "5a0fb2dd88a6420e0a69ec4c7259bcd1fe8f4a80b232c150e11f3da4c68236d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99803095584226de0e850b613fff80995a39fc01e40777c81bdebd43eb0991a8"
  end

  head do
    url "https://gitlab.com/mdds/mdds.git", branch: "master"

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
    (testpath/"test.cpp").write <<~CPP
      #include <mdds/flat_segment_tree.hpp>
      int main() {
        mdds::flat_segment_tree<unsigned, unsigned> fst(0, 4, 8);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++17",
                    "-I#{include.children.first}"
    system "./test"
  end
end
