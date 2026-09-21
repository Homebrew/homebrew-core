class Gpgmepp < Formula
  desc "C++ bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgmepp/gpgmepp-2.2.0.tar.xz"
  sha256 "6651c5f7f801543d5b676719df9fec8053b0a6f5aba40b98ca0d2bee11136f30"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepp/"
    regex(/href=.*?gpgmepp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e9d5d7f67a5806f6b0ad13d61c991d608f6e6f0db03b9c69eb9294c6d5e5db30"
    sha256 cellar: :any, arm64_tahoe:       "e182e7620bfe67c8ff4d39eb3061cbd7dcff08bc3ec7d51435f6575d07426897"
    sha256 cellar: :any, arm64_sequoia:     "bc1ad2a64e672863fe6501a4877e9f2f5d7cabdd4111cf4093badfa1e6928e3a"
    sha256 cellar: :any, arm64_sonoma:      "ee685b491a5ad9bc01f2ad9922991fad349e9f9518cb6dae24bcb0fc5ce40f5d"
    sha256 cellar: :any, arm64_linux:       "4c4ea2ca39fa1c05c89246467da34a2cf09d78f747eba8e238629f9a00987825"
    sha256 cellar: :any, x86_64_linux:      "704771d1593f60d76a471cd903fd09b672c7c8fddad84dc8de7eed2efff0c012"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gpgme"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp_r (pkgshare/"tests").children, testpath

    flags = shell_output("pkgconf --cflags --libs gpgmepp").chomp.split
    system ENV.cxx, "-std=c++17", "run-genrandom.cpp", "-o", "test",
                    "-I#{include}/gpgme++", *flags
    system "./test", "--number", "10"
  end
end
