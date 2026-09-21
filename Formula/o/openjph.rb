class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.32.0.tar.gz"
  sha256 "5cb1ebe18e5ee1322d23ff2130b37562d447d1ad5586c3d16cf84be3ae30f719"
  license "BSD-2-Clause"
  compatibility_version 7
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0b8eb7715378b2336cd0dd4b43cbbdd9e70aece80e76b7b3bb6420055adf6c5c"
    sha256 cellar: :any, arm64_tahoe:       "5d007e77d74a266d101de537c05d3c4f03a6936550938e86c03bf7d6e6ca2072"
    sha256 cellar: :any, arm64_sequoia:     "a543eb8908cdb84823c5798f0c7b6355af68338f133806a41746d5c22250e01f"
    sha256 cellar: :any, arm64_linux:       "df596ce6f8fd0855aa63099725d6d391b2aa52d486830b0cee48298d62eb8f70"
    sha256 cellar: :any, x86_64_linux:      "e03661605160485e1ebd99d75e29ea2e1ca5bfd14e788f9d6b3b5b27226af577"
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
