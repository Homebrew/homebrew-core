class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "081caa8698ffdfe2c8f65d043786dc0abbee0afc72d0ebbb51c3a5abcb2da736"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34239da3f2f7776cb63825dbb9aef1f29fa0702926fb34f164ec60b79ba8e8ff"
  end

  depends_on "cmake" => :build
  depends_on "libfuse@2" # FUSE 3 PR: https://github.com/Aorimn/dislocker/pull/340
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "mbedtls"

  # Backport support for mbedtls 3.x
  patch do
    url "https://github.com/Aorimn/dislocker/commit/2cfbba2c8cc07e529622ba134d0a6982815d2b30.patch?full_index=1"
    sha256 "07e0e3cac520a04a478f1f08d612340fc2743fd492b0835c7fb41cfdb5ef4244"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dislocker", "-h"
  end
end
