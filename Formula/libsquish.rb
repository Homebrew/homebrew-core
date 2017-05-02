class Libsquish < Formula
  desc "Library for compressing images with the DXT standard."
  homepage "https://sourceforge.net/projects/libsquish/"
  url "https://downloads.sourceforge.net/project/libsquish/libsquish-1.15.tgz"
  sha256 "628796eeba608866183a61d080d46967c9dda6723bc0a3ec52324c85d2147269"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebfa2b4d94a71334548800ceb00803ed1ed1e91226f6892048f376d73ee7ef74" => :sierra
    sha256 "4af6195448040889de7ada48fcb6fc6dd945e47f001a04807b70b4f5b3982663" => :el_capitan
    sha256 "d887794fa29f03abcd3809db6ea74045d3b8d40d895cf5972d2eda3de86f3ada" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <stdio.h>
      #include <squish.h>
      int main(void) {
        printf("%d", GetStorageRequirements(640, 480, squish::kDxt1));
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cc", lib/"libsquish.a"
    assert_equal "153600", shell_output("./test")
  end
end
