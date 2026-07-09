class Nanoarrow < Formula
  desc "Helpers for Arrow C Data & Arrow C Stream interfaces"
  homepage "https://arrow.apache.org/nanoarrow"
  url "https://github.com/apache/arrow-nanoarrow/archive/refs/tags/apache-arrow-nanoarrow-0.8.0.tar.gz"
  sha256 "1c5136edf5c1e9cd8c47c4e31dfe07d0e09c25f27be20c8d6e78a0f4a4ed3fae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3be15a1432ef534229e44b2fedc889dfb66a9926e6321dc0734533c4ec023305"
    sha256 cellar: :any,                 arm64_sequoia: "301c06180225be941aee32d0b9d102fc348e2fb9370bf2287855694dbec3aefb"
    sha256 cellar: :any,                 arm64_sonoma:  "6b33fffeed666fb78fa66e9f3e2dccec18692815eaff495170bc382a3350e96b"
    sha256 cellar: :any,                 sonoma:        "76d6d0478a00c229569fc038bd5d14e849878ef01c5d33e616b9239367f6453d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "529e8d6aa3e287726a199029bd9906f16a6d17520ea758594338b2dfff1ee328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e76f0d672cc78711442eb6426aa42305a5964e62e88f79cbd4f4bd88cc7d38af"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nanoarrow/nanoarrow.h>

      int main() {
        ArrowBufferAllocatorDefault();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnanoarrow_shared", "-o", "test"
    system "./test"
  end
end
