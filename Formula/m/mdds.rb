class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://gitlab.com/api/v4/projects/mdds%2Fmdds/packages/generic/source/3.1.0/mdds-3.1.0.tar.bz2"
  sha256 "a50fbaf1ac6d135084ff4f4ee72e8a13e6ac6fc62db62bc8752b8d858076b5fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2dc6019c4ac471ee94175fc7f100ace94f0e380a6d6efc48a04bafa98b8c844e"
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
