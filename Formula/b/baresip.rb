class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "3e4694833e81e306cd3df9b45ad17bfdf046d964825e121b5fb44d6df5730ba8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "a43db6c597e8a632e3bf8f207d228e9a7b17837187f3449523ba941f7f3eefc9"
    sha256 arm64_sequoia: "d079b36b478f1de2d997ad1cdf416bfcedd7b0d2ae6e873227c03b58f3cbe019"
    sha256 arm64_sonoma:  "b41025b98e3e4d07cef7ef736fbc775f00de640056266a4e10064aa860e1089d"
    sha256 sonoma:        "9bd944fb2c6eb9a34cc67989aa29ff72de8b0a63fc6b15327cdde09f8b2422cc"
    sha256 arm64_linux:   "265dd54766f36dd4f30c20a7ee63c9ce13a5e09394ebcb2b89d6d1dd5660726c"
    sha256 x86_64_linux:  "6d6ceabd3ab31b16a44a3d41d00780d5b6f40f6d34c31e8342e08bf12d0d03c1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
