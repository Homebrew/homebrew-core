class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "3e62b66cb833f22561ec3351647efb3c488766978d72f56de1039a7e5ddf70a9"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "25ef99ebac73b8b0dc703f1773e665976900a35a1340934412a4bc2be4a5f8cd"
    sha256 cellar: :any, arm64_tahoe:       "58d671897ab0d8ab8cd184d64f5104bf8404a6b6a18c1070712d90f0dccd3a83"
    sha256 cellar: :any, arm64_sequoia:     "85854f69526a301c3cab12c0d3f02d3c6322507268f95f4a121d3c49cb102806"
    sha256 cellar: :any, arm64_linux:       "2605cf8040e30cf8b692ae74dfe6b473790fdcc99910c2a20b452eb430cba2eb"
    sha256 cellar: :any, x86_64_linux:      "8d650cecbcd048d956dd7b177143f4f32fb55d6a009dc0a5483b3738461abafa"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{include}/re", "-L#{lib}", "-lre"
    system "./test"
  end
end
