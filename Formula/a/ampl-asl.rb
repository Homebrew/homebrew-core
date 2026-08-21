class AmplAsl < Formula
  desc "AMPL Solver Library"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/asl/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "57b767161fd95869757daa0761d9b19fa39ad5de4315f95a3c0dff08b0d4c4f2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e93cfc9570652c4c096b01942081b983ebafff86da8edbaf143992fe5c97338"
    sha256 cellar: :any,                 arm64_sequoia: "df57b49399130fbfff59616c73f30a0751241e422bc817013870c339bb213537"
    sha256 cellar: :any,                 arm64_sonoma:  "80dc283a53e12edbaa054669f376bc5fb6d54f90b4e94d9fa6b4119d46127531"
    sha256 cellar: :any,                 arm64_ventura: "d8e6c8531c3fe9794f920361660e8e574a989ffb2be3d9bd2a175c765fce5937"
    sha256 cellar: :any,                 sonoma:        "63dc38641db70dd681e96b4845458fbe9aed065dd896dca0ef8daba1c98f3724"
    sha256 cellar: :any,                 ventura:       "60cfa373989ced8460b2d010ee473cf4be786b867f3198edc4f791fef9e80584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b5fcd3e7c6634a5718574b024cec7f43f90085ce233e9d7038c62a5915b351d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed2974a2535806181150237068f2125ab75f64fc06644cd972b66278cfb8dda"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
    ]
    args << "-DUSE_LTO=OFF" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include "asl/asl.h"

      int main() {
          void* asl_instance = malloc(sizeof(void));
          free(asl_instance);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/asl", "-L#{lib}", "-lasl"
    system "./test"
  end
end
