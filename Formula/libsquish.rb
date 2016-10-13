class Libsquish < Formula
  desc "Library for compressing images with the DXT standard."
  homepage "https://sourceforge.net/projects/libsquish/"
  url "https://downloads.sourceforge.net/project/libsquish/libsquish-1.14.tgz"
  sha256 "5ea955dc7b566d8c30b321e09d35ad7dc7c2dfa0c3330829b034f69cf92ebc7f"

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
