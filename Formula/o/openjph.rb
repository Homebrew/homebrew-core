class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.23.1.tar.gz"
  sha256 "8a0357075fb92feeaa36e23de78f81a869c7bb6189091cc34f41bb061c1db22b"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc011330b5b9027fd34c9de45efaed22cc586cae497d7b7284a4865c6a4433c1"
    sha256 cellar: :any,                 arm64_sequoia: "6316c6244f02f6df98cfd111e247b53923757ef116c56be82397e11f96b61f80"
    sha256 cellar: :any,                 arm64_sonoma:  "97965dcca7769e4d067fc5bef0151f708543fd9828b9af63f5e463b3fa1dac70"
    sha256 cellar: :any,                 sonoma:        "89a826e5563dafecd56e8d053bc662e6557aaf12fcd988cdcea0773fb09687e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50f979c42e271cd7168c39da4e2d03c093f8af03e3beb2271c8064a10013be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8318b92040fbfe6defb4355a728790812584940e05b79ba6485002abb539851"
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
