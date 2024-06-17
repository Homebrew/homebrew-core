class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "6c29f3811bd59585fd369e18a70fb43bd5a322df84e62ad4ac97832f9b1f0876"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c6f894e11f48acf9a6a7b8977f62add272de70d1999d9f2adbb003cc35b57d2"
    sha256 cellar: :any,                 arm64_ventura:  "667c34a653e456275f9f3eaafffb6f408e9b7dc3d610bc099e733598178fdb9a"
    sha256 cellar: :any,                 arm64_monterey: "55a1698fc0e5a43a5774b1a614848bf5bf6891293ca9386f690a4c1073bdcafd"
    sha256 cellar: :any,                 sonoma:         "7e7697ae4f310bf9a797dbf2135eb8fcfc8779ea50aa279429c371b6b2514728"
    sha256 cellar: :any,                 ventura:        "7cd907d0808a887408dba781bbfb0166c62b41b21e76b1bbaa5e6fbf5fc029f1"
    sha256 cellar: :any,                 monterey:       "37b9f647464722d63e8450db7be314ce56e1a96babd73e92001009f1d122f2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d6f05ecd4a9a3a551a6a4cf93d4ae1f34ad28bfcf674873f215522b568557a"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
