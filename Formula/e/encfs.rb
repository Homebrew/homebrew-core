class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  # The code comprising the EncFS library (libencfs) is licensed under the LGPL.
  # The main programs (encfs, encfsctl, etc) are licensed under the GPL.
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/vgough/encfs.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "1952d5ef71cdd862776574b47add8ae4649b907c6ed734fac41b7357d13250f7"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"
  depends_on "tinyxml2"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DUSE_INTERNAL_TINYXML=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
