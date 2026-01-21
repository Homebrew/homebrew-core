class Nanoarrow < Formula
  desc "Helpers for Arrow C Data & Arrow C Stream interfaces"
  homepage "https://arrow.apache.org/nanoarrow"
  url "https://github.com/apache/arrow-nanoarrow/archive/refs/tags/apache-arrow-nanoarrow-0.7.0.tar.gz"
  sha256 "bb422ce7ed486abd95eb027a1ac092bbc1b5ed44955e89c098f0a1cb75109d5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80ebd3cac2eac2d67f2563d335cb9145d94f38a2403ee1470bb3099732f75a0a"
    sha256 cellar: :any,                 arm64_sequoia: "bf71bbbdde9c971b89659c9ae196fc56ce3e7b180caacc3640a62cf20b7c62f1"
    sha256 cellar: :any,                 arm64_sonoma:  "672338d155c58aa60c7fe8107909b6c12c7b39d97581741b6073d6941867bafd"
    sha256 cellar: :any,                 arm64_ventura: "997e95fcd0948c90c9680f98fe02c74b91dcced1937cc2dc74940711753e8ed4"
    sha256 cellar: :any,                 sonoma:        "5f4126977b7e17a6701822ec3529b8f550cd39d48c2de275e35d0a5dc0588609"
    sha256 cellar: :any,                 ventura:       "2c50ca39d9ad131e3bc0ef1583f301a79e41cb8831603b472e7c4bdc8f6a47a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fc86678c0558fba9a493d4dec9e68b8c0fd070c4765df27c1bdb3c083ab4ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8c7cb7755e696b37ea6bc6a64cc1602f03eddab8e89e285ef17b138e98658d1"
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
