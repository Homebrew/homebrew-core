class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-2.1.0.tar.bz2"
  sha256 "3359f70624f2358a773acb39c0ebf2f36954c01895fc9c0f60e1ab0916bd07e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a5302edc4b765664e2ae40d09f03c6ca7dde35ff915076d4c74d5772aa43da4"
  end

  head do
    url "https://gitlab.com/mdds/mdds.git", branch: "master"

    depends_on "automake" => :build
  end

  depends_on "autoconf" => :build
  depends_on "boost"

  fails_with gcc: "5" # for C++17

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
                    "-std=c++17",
                    "-I#{include.children.first}"
    system "./test"
  end
end
