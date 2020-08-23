class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.6.0.tar.bz2"
  sha256 "f1585c9cbd12f83a6d43d395ac1ab6a9d9d5d77f062c7b5f704e24ed72dae07d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "c7415479dc1b23ba867eef310cd265d6813ea9523591a2d30670f3ee20a99923" => :catalina
    sha256 "ccfeb176c14e310b913302c74ba30d5973184662e62060ec8eea0f16c931f607" => :mojave
    sha256 "ccfeb176c14e310b913302c74ba30d5973184662e62060ec8eea0f16c931f607" => :high_sierra
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
