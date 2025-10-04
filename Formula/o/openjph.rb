class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.24.1.tar.gz"
  sha256 "5e44a809c9ee3dad175da839feaf66746cfc114a625ec61c786de8ad3f5ab472"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "afb314954eba8de9b1d7f865f06ee99ce2eadf7bb4e31c6c8582de04ce014210"
    sha256 cellar: :any,                 arm64_sequoia: "a77e4cad9b430d6fa58f8f600871cf4f71b7580cc4f4024ed6b678ce0c0c44ed"
    sha256 cellar: :any,                 arm64_sonoma:  "54191a0350c2d6565e69eec865470736869e127d982075cd7a84cce48bff0aae"
    sha256 cellar: :any,                 sonoma:        "65ab746593d1052de6282ea27514078e268eef5af866b3a5785ed8dcc6288350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5371b52b17a96a99535a3f620c6239f43a3a44b5885c31f7a73db4875201f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8810ecf7daf3f8e5e1b2d8fee6f399de5f77b16cd79aa1de43c34b0799eb55f2"
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
