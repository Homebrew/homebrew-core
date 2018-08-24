class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.4.0.tar.bz2"
  sha256 "496b11564e2d95615090bf31a3524718260c5e8246e9d552216c4c56f5a24529"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cefe5ebe9c9580d93cdc439a0e3f17ec44e8cc88cd3243317c8e7711544e669" => :high_sierra
    sha256 "2cefe5ebe9c9580d93cdc439a0e3f17ec44e8cc88cd3243317c8e7711544e669" => :sierra
    sha256 "2cefe5ebe9c9580d93cdc439a0e3f17ec44e8cc88cd3243317c8e7711544e669" => :el_capitan
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
