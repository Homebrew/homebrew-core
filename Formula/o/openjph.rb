class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.18.2.tar.gz"
  sha256 "6c1a895f5957f58b6ecebd136d4553a6baa73b1cc20432dc542312abfc0eedf1"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b2e52e0b53686a8052c4c6393cf8dc8393c5ee7d378171a6b91c142e28bc345d"
    sha256 cellar: :any,                 arm64_sonoma:  "ce8b5e69d579b87aae36adb3179d45b06d4ca6c25ee5351e64f6cb45f3f5b20a"
    sha256 cellar: :any,                 arm64_ventura: "4dd5489c85b70cfc0f1f1b35cf2be900d1cb889aaae10629afa70e09bbb2a1dd"
    sha256 cellar: :any,                 sonoma:        "3d2726e4725666d1dabde3592f3d367d4a860636bc63e18f03ed8132caaf8d53"
    sha256 cellar: :any,                 ventura:       "0b20bac9fc8a25a93cdbfa1f5a9f2320549ed02c9598a95a53e04e6f0db3a6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6e1c61b9326ba4e7b6e7d9394944daf89aa407bed9cb0995ca07e816c905da"
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
    assert_predicate testpath/"homebrew.ppm", :exist?
  end
end
