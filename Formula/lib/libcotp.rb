class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ff0b9ce208c4c6542a0f1e739cf31978fbf28848c573837c671a6cb7b56b2c12"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "criterion" => :build
  depends_on "pkg-config" => :build
  depends_on "libgcrypt"

  def install
    mkdir "build" do
      system "cmake",
        "-S", "..",
        "-B", ".",
        "-DBUILD_TESTS=ON",
        "-DBUILD_SHARED_LIBS=ON",
        "-DHMAC_WRAPPER=gcrypt",
        *std_cmake_args
      system "make"
      system "tests/test_base32decode"
      system "tests/test_base32encode"
      system "tests/test_cotp"
      system "make", "install"
    end
  end

  test do
    system "true"
  end
end
