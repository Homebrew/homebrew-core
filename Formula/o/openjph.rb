class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.31.0.tar.gz"
  sha256 "fe169dbbaae71a169a0a6a68dccb346616193252c1ca044217afa0d5d1dc436f"
  license "BSD-2-Clause"
  compatibility_version 6
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3b748fc99e37f3af562e582669a5defaec38dee6eba88d6e3a9b8e22811a415e"
    sha256 cellar: :any, arm64_sequoia: "5f4edc3e48c906383aa0cc3fd1671c5a6e07f2cdeae5d41064488c2143f71ffa"
    sha256 cellar: :any, arm64_sonoma:  "692729a850222f277dd2d01e09e997e4cdeb7996586c6308b64390a7093fa624"
    sha256 cellar: :any, sonoma:        "c8af7daeeba0558f8c029418e0b342ed634890ac0f910db84b28becdba5263a5"
    sha256 cellar: :any, arm64_linux:   "f436eb20cb5ce29ed1b56455b6fdba74221b23f8d668c8fda0fa246d627bb8c8"
    sha256 cellar: :any, x86_64_linux:  "f46e8ddbc8b67794009720090ebd74a774a85d2029a7c54f97fc8b031e35466e"
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
