class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.27.3.tar.gz"
  sha256 "f96808ef72cf3acca73a52123bda3e680f6550dfb4774ad7de57eb3ce26de57a"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1017ceff9efe338afe41d3457605873b38a4f64051a67e79dc129d6178b4b5b9"
    sha256 cellar: :any,                 arm64_sequoia: "ed56deb929a1d39ececb4f471e89c7043ea9a7f0f1e0aef8622f5217c559eae5"
    sha256 cellar: :any,                 arm64_sonoma:  "88271d81447d931c1b6150fe372b8787e7524fd16e965b64658db8468ef638ec"
    sha256 cellar: :any,                 sonoma:        "70728b71d49d15add086d75bfdcf0802dc39817bbfbb4e09501dd94476fe4c49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdf747bdc76a1151087b1c7efe1db18e1fd7e938e078333d23a52280fc6d992e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9fa791196bd379fa3a8d0d1ee9c852096073895d57d2f10d05968ddd2f47cf"
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
