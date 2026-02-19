class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "be6bc1adb74bac8ea866e7fff655f9c9bcd9dbceebf7337649c7ac834c7028dd"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b518ed44afbdaa37daa04f240c4be3e0e505e5589781d3c18d9da0e64cd73f39"
    sha256 cellar: :any,                 arm64_sequoia: "60959942a578bab8cc5232f3d682621c6f5b940521b57ccd9c9f1d584bbdc54a"
    sha256 cellar: :any,                 arm64_sonoma:  "16c9765bd2ff85b33b109a768b705dfbeff5247409d2c075451b38e19e401a8b"
    sha256 cellar: :any,                 sonoma:        "049fdad9327623dc477a3ba297cd85b6e51d59048e19aa81a79f45b592e8ca05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e41770d8e0635911c6d837ff71b7134795c4b6b7a984d145e03fca44dbafcfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e1675c3c544dcd00fae0667a438761a7835d93f088cb785bbe1ad734f68b1af"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
