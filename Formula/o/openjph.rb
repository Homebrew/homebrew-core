class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.25.3.tar.gz"
  sha256 "815b0d345daf3bbad72f3930d4f6c831643dcb2b734d8bb44d871d68db12f4d2"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33e0afc346e8508a88a28d9397ce999f8bd261dbb68dab01fe756d55f9b9e98b"
    sha256 cellar: :any,                 arm64_sequoia: "dfd1a9d3d03f41d8119ce1a9ed58229b1be6e8312690cb488d462e6d41befa3f"
    sha256 cellar: :any,                 arm64_sonoma:  "accdc668da032e466e863792ff037fcf08640bf6a69878600c818379151b0f8a"
    sha256 cellar: :any,                 sonoma:        "1db573c45c6865463cf266be0654c4917e76d3f0193bb0ae799ae8fb1e6ce901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc537ac808c7d5a2d5285b8a709dc0f87516146e63a4f68db659eda37b3a130d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35aac4781c1316f2c2e56b14b3e72ac34b932c7ef5859ef33fd46d46614ed95"
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
