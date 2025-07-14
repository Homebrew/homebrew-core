class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.21.3.tar.gz"
  sha256 "4dfa87ec8e28c8a30c038969cdd3084d2e8688b364efd83599c3fa90f29457e2"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b5a932d433a1f8c2b662cd47bef684b55dc099cf4b2e3413345b3d9d11fda98"
    sha256 cellar: :any,                 arm64_sonoma:  "1c48a53eae98df23ca1233015737b21813964be181e235fddc9114cb713684a9"
    sha256 cellar: :any,                 arm64_ventura: "72be442d20e1013f622eae2b9c19c2b0fd2cfb848e86fe5eea5e01d97ce4f972"
    sha256 cellar: :any,                 sonoma:        "0d25456484990acf8defc0c3c4dd02b723982d94be54d7e0f9021a6d0d714cf1"
    sha256 cellar: :any,                 ventura:       "77677d9e0a0e7c753497049613b5136100699018e3965fd9253dea574999662b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e748967950f404f0e1a127e5c360e049a0429bb5c0fc137a4be1a9a7f2843de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71b74702c2ab4f27660918b18d11fc528f15e135b1a28ae7f94df1c4c087f402"
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
