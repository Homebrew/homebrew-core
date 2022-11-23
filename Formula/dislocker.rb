class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "961f02363415f3d3080c328184ad61d12511440e2572e90842a93f4a6c62000e"
  end

  depends_on "cmake" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "mbedtls@2"

  def install
    args = std_cmake_args + %w[
      -DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE
    ]

    system "cmake", *args, "."
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dislocker", "-h"
  end
end
