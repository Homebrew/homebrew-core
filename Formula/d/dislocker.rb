class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "73716f0bbfd63f9b3cc58e49ccc3c6b40ee8747ed1fd705cc1713d73345164b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ba1a9f3dacd564fed1a0fe680107dd17d2f5213d5adde210d058f1fa29e87b24"
  end

  depends_on "cmake" => :build
  depends_on "libfuse@2" # FUSE 3 PR: https://github.com/Aorimn/dislocker/pull/340
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "mbedtls@3"

  # Backport support for mbedtls 3.x
  patch do
    url "https://github.com/Aorimn/dislocker/commit/2cfbba2c8cc07e529622ba134d0a6982815d2b30.patch?full_index=1"
    sha256 "07e0e3cac520a04a478f1f08d612340fc2743fd492b0835c7fb41cfdb5ef4244"
  end

  def install
    # Workaround to build with CMake 4
    args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dislocker", "-h"
  end
end
