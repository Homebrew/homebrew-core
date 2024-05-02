class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.12.0.tar.gz"
  sha256 "e73fd0b12d95c0b61884579f61c26da7461335146e7e9c84f4a2dd5c9325bb4f"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bea770baa09232c1e762266754c8cd36470bbcbacbe44c16a963f1d5ac757cb"
    sha256 cellar: :any,                 arm64_ventura:  "05949271220c55865c9ee0d0d0cfe73c35c22139f6cc91d0faa8cb5939b71180"
    sha256 cellar: :any,                 arm64_monterey: "c67285c6389ad059409ef22cd35a8556bfd819f3195659ba3fb727f6883e258b"
    sha256 cellar: :any,                 sonoma:         "b4f67cd4906ea92577e8add5b1c777e488a070b8680b0a30739f06be4a19441e"
    sha256 cellar: :any,                 ventura:        "4d3e554f4c1c6fdcf483ee04a2dd1f5c0973e50275a820280dae8da5dc50a5f6"
    sha256 cellar: :any,                 monterey:       "19770c99f4e37bc087df7ef5eea3f483349deda1dad043e548d6150ffcc69692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12825ef34ba7a133021d2f7894b012619fe14988b0463d01a592125de7ed58ef"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DOJPH_DISABLE_INTEL_SIMD=ON" if Hardware::CPU.arm?

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
