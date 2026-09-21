class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://gitlab.com/api/v4/projects/mdds%2Fmdds/packages/generic/source/3.2.1/mdds-3.2.1.tar.bz2"
  sha256 "2ed33238ca9e42cc9ffa99a14adc80d86c09c0b0d001f876724ae3a167435048"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "304f5fdd92f650a15e6cfc1ffdcb88919934de6a002e1e6b5e6358ca1da7251d"
  end

  head do
    url "https://gitlab.com/mdds/mdds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :no_linkage

  def install
    args = ["--disable-openmp"] if OS.mac?
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args, *std_configure_args
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
