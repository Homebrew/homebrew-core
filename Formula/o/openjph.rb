class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.27.4.tar.gz"
  sha256 "4bd6c75cc74721b1a40c3e07206621d0c953d0b21e9f63c9982a8ecb4a6f326d"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cd9b15e9f756a82579559662bc1b89075f89b9c9d4c79aa9788cd86faf79a673"
    sha256 cellar: :any, arm64_sequoia: "2522f9415fb6582c665cb8b172d7be00803a2810c14849469d54a8dd066ce158"
    sha256 cellar: :any, arm64_sonoma:  "66dcd6f07aec1b08799be8cccf11d0d74ec88e8f9abc0a4ab896ee5f76d61ada"
    sha256 cellar: :any, sonoma:        "877fabfcdf0ae0a06a82c14c84cdc2812261b02b4d64dcef229f51d5a92b4de1"
    sha256 cellar: :any, arm64_linux:   "78939ad6850e572bf9077efd528f58ed0a9ecf88d5c1d5c04abb7175f5716b9d"
    sha256 cellar: :any, x86_64_linux:  "c147b323885f5ff48296ac124a1da19fe84e4ad913fb5ea1d1817c33e17e6ae2"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test.ppm" do
      url "https://raw.githubusercontent.com/aous72/jp2k_test_codestreams/ca2d370/openjph/references/Malamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin/"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin/"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_path_exists testpath/"homebrew.ppm"
  end
end
