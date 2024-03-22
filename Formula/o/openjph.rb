class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.10.5.tar.gz"
  sha256 "fc1e43fb1e8a097f883f5fe98794327eb96c4bdf2c53cb633537b061af4c99f3"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb79ae079a51db422be1a0275ecb7424b589086c5b3c7b1be634e9681d261fac"
    sha256 cellar: :any,                 arm64_ventura:  "cff679464b6b5d5ad2bfcbef29749f27f96bd341909501739cc2a2454ce4d0c5"
    sha256 cellar: :any,                 arm64_monterey: "05f0aad1b5080a55e9cdcf426a3a23f0cd27fac709387e69496843cbf4d59c5b"
    sha256 cellar: :any,                 sonoma:         "6c192d50ea5ea8a2e3012522947b2e5265f6eb39bd78da1590863d55b210933b"
    sha256 cellar: :any,                 ventura:        "7bcff268ca6a7768f6551ccf0bec0a929fc261151b45af0bfa47a07da93ac71f"
    sha256 cellar: :any,                 monterey:       "bbbe72eb4e4b863bf4808a453500eaaa538c2b67d2d83baa5202f46bddf620d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0554239581dd1d618a2a1b7d7d680279dccad49edd643f7e03989a886682f48f"
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
