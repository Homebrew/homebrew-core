class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "3e62b66cb833f22561ec3351647efb3c488766978d72f56de1039a7e5ddf70a9"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3bc1fe6c9130fe3c83d0b058bd583cb6fa991d4d9c96ead0c4d7d14a9abaedc6"
    sha256 cellar: :any, arm64_tahoe:       "ed767b60fbdd48af90f0d207045f3e8a61adbef247a8a122f8ded85acb92fab9"
    sha256 cellar: :any, arm64_sequoia:     "0d8642f74e32aa81cb7d0790efc1d6eef82522e23cebe3dc1425730d80c7dda8"
    sha256 cellar: :any, arm64_linux:       "8e633dd6d9be87bdd21014858c964c2fed42bfacbb6136e0e46e29ad545dad3f"
    sha256 cellar: :any, x86_64_linux:      "7db66bb147cee5bfa5a3abe999ba3908a15649945d4e662d25d80fd99cf361d8"
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
