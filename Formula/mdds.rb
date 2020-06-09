class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.6.0.tar.bz2"
  sha256 "f1585c9cbd12f83a6d43d395ac1ab6a9d9d5d77f062c7b5f704e24ed72dae07d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3a34d290152006eb29ab3995754f57de22dddd7c8d95c95c98af206324a12041" => :catalina
    sha256 "3a34d290152006eb29ab3995754f57de22dddd7c8d95c95c98af206324a12041" => :mojave
    sha256 "3a34d290152006eb29ab3995754f57de22dddd7c8d95c95c98af206324a12041" => :high_sierra
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
