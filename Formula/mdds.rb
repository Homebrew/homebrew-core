class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-2.0.0.tar.bz2"
  sha256 "5a0fb2dd88a6420e0a69ec4c7259bcd1fe8f4a80b232c150e11f3da4c68236d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "602a95bcf70ac8445a3c964c67c423108b6a58ca5b743d9eb26f5a017776c63f"
  end

  head do
    url "https://gitlab.com/mdds/mdds.git"

    depends_on "automake" => :build
  end

  depends_on "autoconf" => :build
  depends_on "boost"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

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
