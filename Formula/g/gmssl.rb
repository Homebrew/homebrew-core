class Gmssl < Formula
  desc "Toolkit for Chinese national cryptographic standards"
  homepage "https://github.com/guanzhi/GmSSL"
  url "https://github.com/guanzhi/GmSSL/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "b0bb50f935c1b35c614ff0a7f235b00520b86a3e9a659a681d77be6dadcb5d6b"
  license "Apache-2.0"
  head "https://github.com/guanzhi/GmSSL.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "034ea371e7c245809dff7f750d8bb61b0a01a8dc9dcda71f27b0fb5bf8ea84e4"
    sha256 cellar: :any, arm64_sequoia: "49f414f3778661c1f077a7b03e75a098fda2fbc9aeb5ca8432004bd04f634f81"
    sha256 cellar: :any, arm64_sonoma:  "6f204d59e24dcb3cf27959687a1bb363f73608f8a7b12f512792ad9578a083a8"
    sha256 cellar: :any, sonoma:        "77254be1e176b9d6690733818cb2fa8db2d7ef1fda1b0346675b5ff2b0e08399"
    sha256 cellar: :any, arm64_linux:   "93def4011f09adf0a9265b3c06f428d755960dcfc9b7d2e796d667a4f11c8e79"
    sha256 cellar: :any, x86_64_linux:  "ce2ca685c64112a13e10adeaaf785703412daf4361ae6eca8301ab20f492a1b0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected_output = "ba7cc1a5be11d5f00dc8a88a9fedd74ccc9faf4655da08b7be3ae7e3954c76f1"
    output = pipe_output("#{bin}/gmssl sm3", "This is a test file").chomp
    assert_equal expected_output, output
  end
end
