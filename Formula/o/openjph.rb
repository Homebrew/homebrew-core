class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.21.2.tar.gz"
  sha256 "5c25f5fe820ccb4fee3b7a0d3246bf836508e313708f0b57f3654dbe8b0c4a01"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c73a3e7f1c8a3addca3acc291298227987a27d63d64b39ee16d336805fa393bc"
    sha256 cellar: :any,                 arm64_sonoma:  "a0afe7ab8f37d6886c997d54bfdb788ad8199ea1f67ca6910cb201288bb54d02"
    sha256 cellar: :any,                 arm64_ventura: "d79bb7861bd20f92c7047d10358b04be37f4b2c59b6fe5fa1c02344a2ce3d8b3"
    sha256 cellar: :any,                 sonoma:        "6fc7ba2486fef01ef88051d57debef07ece8497c65c192e440cb9109f318a159"
    sha256 cellar: :any,                 ventura:       "92b8a6f1bae509c87aff49ab8c3b847ffa94b121b2a02d744b06612423b19dfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b18370cd84f883815cc92e1832552dbc7bb3ae6c9861dccd3d9594a9818e58da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1bed2eba22b7dd9c77079c62bf6d6d928a2b7056a631cff958aa181adfef71e"
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
