class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.13.0.tar.gz"
  sha256 "65c044d58619b846612205947f0e379edf037964841a0878d88ebc235819302f"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a70cb0ed15dfbd636b1152574d142af68322d672eeb1da6109336d2c8895a6c5"
    sha256 cellar: :any,                 arm64_ventura:  "c7119ca055601496b43707b74def793793a16431ce34b26d78dc074215608479"
    sha256 cellar: :any,                 arm64_monterey: "433c1ded3dee39791d16eb7ffb684f3dc6ef820a6eae94f2c1226bc8b5b9b10a"
    sha256 cellar: :any,                 sonoma:         "3494dd31ba9760212282a1345b2ae49b14f6b9b1b4ef57fbe9b8652d37a31cec"
    sha256 cellar: :any,                 ventura:        "973d6bcfcaedca584fd6a70e2b89b75524fb31d5f5194366d6443ea0a3d9525d"
    sha256 cellar: :any,                 monterey:       "e8866f337a519bba6f360f3d839e2035e4acc96f4c9bfbaab7c1c0b9ee8abc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd0dda016b93a6dbd47c7566db4d8c156cddebd6083e24293e177058667de594"
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
