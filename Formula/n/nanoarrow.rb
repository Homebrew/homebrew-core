class Nanoarrow < Formula
  desc "Helpers for Arrow C Data & Arrow C Stream interfaces"
  homepage "https://arrow.apache.org/nanoarrow"
  url "https://github.com/apache/arrow-nanoarrow/releases/download/apache-arrow-nanoarrow-0.9.0/apache-arrow-nanoarrow-0.9.0.tar.gz"
  sha256 "801200a0e95e869d5c4bdeb5b535dba58551482bb782b7dc8bd599c8b6e8cacf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c67c700f950c7bdef70be90de5f7d6d19af2f1e7bb131975c542bb0ff91b63c7"
    sha256 cellar: :any, arm64_sequoia: "56dd6ec71ec9a068df2f6c07163961b6457047854634ff65bc137120d0ffe4c3"
    sha256 cellar: :any, arm64_sonoma:  "82b2b1a752b94b669c670610266f1f654b6dbcb0ee3545944f5cd36f762fa256"
    sha256 cellar: :any, sonoma:        "73738cb0dce0d4c6a360ee252a0ed9feb0f52b5ea5bca6b2bfba2219bf05c64d"
    sha256 cellar: :any, arm64_linux:   "e88bc81d87f9dbd08a57bbce97b58074012b169d89867e643ff8c43ddde2f051"
    sha256 cellar: :any, x86_64_linux:  "0f656bab74987e1d095c0a5fb0c5ce96ac8d135cb1fc2cbfdd3b1ef3bc640fce"
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
