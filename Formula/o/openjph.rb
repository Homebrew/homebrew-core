class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.13.3.tar.gz"
  sha256 "94413feb9cc18d6d25ffb2cdc7f941efabb69fce5a30b2e566f7dfc57d52622e"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0cb41dfa72892e5207b0733c143fb7ca4fb203eb4e896f2e126612ad0194c12b"
    sha256 cellar: :any,                 arm64_ventura:  "1f8addbae3946ef0b0e7fdadf86a10cb7618dc352b050818171f4a42f3d1c2c9"
    sha256 cellar: :any,                 arm64_monterey: "36002018fef9d5b831bc903190c7ed9ec4bebf5a5153d3eaa46930ed8b0b4a54"
    sha256 cellar: :any,                 sonoma:         "cbcc158009712692e70cf710793df0d2a1c744b0bdb40542ac3a243c156fc6e9"
    sha256 cellar: :any,                 ventura:        "f0f8f2015503750adf954beea942bbbef2ee862107ab8f87b9ae59a39629c097"
    sha256 cellar: :any,                 monterey:       "38b67a2fa1c00ea1798e36c2a1a11d68ccf4e11254f12aa4c26090a4ed2bbbcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1ba1d07e5cc818c3d96012ea4a1cf75a8355d017ea1e289a0905de2c3fa92f9"
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
