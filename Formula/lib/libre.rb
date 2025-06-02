class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "31ecb7f7a5569ec0b3d85526c469b24c47673c802d45c58cb13f96a9365f4f14"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4983d98e34594c1af961549d8b4991421eae2e0cd1fa0d69597e623908a927e6"
    sha256 cellar: :any,                 arm64_sonoma:  "4bba3d7970ab3d41fe8609485685d8b53f75801c52a2c88f0c2cf83c85260e71"
    sha256 cellar: :any,                 arm64_ventura: "7ac577319687be8c0c1a88ed24aab3509c489140c32d9088d3e3a490634c8e5b"
    sha256 cellar: :any,                 sonoma:        "fd33f97a24e6f063f2cc8dd059cd55c69a9769fe7ce5dad231a52ea57bd82e81"
    sha256 cellar: :any,                 ventura:       "95f939b11e90bb13695da227a90f9d26257f261082586e118ddf783b7236b1d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27d259496e09f08957f633a2d7730a85a740999e8961246e389fd8352a325ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f66e9290acb5554710dbb0d0827040d80f835b3d77248e347a4958f814d0634a"
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
