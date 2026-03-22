class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0c9f36fe94169843d624f2cff98960d9dcf91a70948061a7c192dc44273e5a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20635c3bd30ada8a1bb95f87460ce8fb7c1e7b42691c7cb56fbaa2e74d407f00"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "mbedtls@3"

  # Backport support for mbedtls 3.x
  patch do
    url "https://github.com/Aorimn/dislocker/commit/2cfbba2c8cc07e529622ba134d0a6982815d2b30.patch?full_index=1"
    sha256 "07e0e3cac520a04a478f1f08d612340fc2743fd492b0835c7fb41cfdb5ef4244"
  end

  # Backport support for libfuse 3
  patch do
    url "https://github.com/Aorimn/dislocker/commit/7744f87c75fcfeeb414d0957771042b10fb64e62.patch?full_index=1"
    sha256 "63ed9e08ebdad3ee97eb5fc0f3bed67231043b8505a007580d3bc3051c4daa7f"
  end
  patch do
    url "https://github.com/Aorimn/dislocker/commit/b6aa30ae21a631ef2300f230437fe6a8ebf1ab70.patch?full_index=1"
    sha256 "fee637f1af9c81f0426925a16c91560fed61ef701913f52fe451516de33183ac"
  end
  patch do
    url "https://github.com/Aorimn/dislocker/commit/7b14a6aa71cad78648443fdec81a5e557903b961.patch?full_index=1"
    sha256 "80d0db6ba8dfb6f6fc60e94eeb75ab9284606b3e5dba14eaf3460335b9a0b8ee"
  end

  # Backport fix for CMake 4
  patch do
    url "https://github.com/Aorimn/dislocker/commit/337d05dc7447436539f2fb481eef0e528a000b66.patch?full_index=1"
    sha256 "7bec70c3528e34949c31ace9a90ee36829fadc7d31a8ad99b707c01d98c74afb"
  end

  def install
    args = %w[
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
