class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.27.0.tar.gz"
  sha256 "f6768e927d8e4e4884a2efcf500a88d1b6714a48d69516332a9256803a3c8343"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d3a100f87988d065af89b8b1c41f3686dfb1ac968f9443eba987df977670c65"
    sha256 cellar: :any,                 arm64_sequoia: "1b68807b52a9fba72e4c834a57220a47b853d990ec201bf5b9d2c4d55845316c"
    sha256 cellar: :any,                 arm64_sonoma:  "09bc4f283e7ee17f0ceaf049c677f4dcb330837974eff39ae5ee9a67bd7059f4"
    sha256 cellar: :any,                 sonoma:        "f214b0fe0180d81ae507d1697ea76c390b65b2dba85e05df68f85d3ba46ff8e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b2a842bdf4993c958cd0acda26bbd9ca71de2a1dc047b17e6d88802e720f18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44bd792d2f05cb7c8ce6462795c235f1460abc90f8b548bad9223a9689ae620e"
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
