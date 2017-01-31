class Libsquish < Formula
  desc "Library for compressing images with the DXT standard."
  homepage "https://sourceforge.net/projects/libsquish/"
  url "https://downloads.sourceforge.net/project/libsquish/libsquish-1.14.tgz"
  sha256 "5ea955dc7b566d8c30b321e09d35ad7dc7c2dfa0c3330829b034f69cf92ebc7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f1732fa88d487966e4be82c8d737a3fcd9e00d43c8dc3ca876df24732581c0e" => :sierra
    sha256 "150f50e0ede60e911ef58e799cbdc2a58ad49515223a5c331e3c03b7d1a0685d" => :el_capitan
    sha256 "82eb7b6b74b51b1b93e492ef174ad80a5dd3d5f38d308ec8b6ae69fbe0e68a71" => :yosemite
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
