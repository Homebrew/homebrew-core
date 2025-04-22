class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  # The code comprising the EncFS library (libencfs) is licensed under the LGPL.
  # The main programs (encfs, encfsctl, etc) are licensed under the GPL.
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/vgough/encfs.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "7d77f8ffc7974b777c3a753c7388209c3c6313a0867d9845a84bd7cdcfc2f94e"
    sha256 x86_64_linux: "526d5bef867b8dc2246146ce5936e25b9a53ff26721fb1d79cccb6d82a3d2b96"
  end

  # see commit, https://github.com/vgough/encfs/commit/aa106e6eddcc16ce7f763c63e5f20dd9eb7f0f52
  deprecate! date: "2025-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"
  depends_on "tinyxml2"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DUSE_INTERNAL_TINYXML=OFF",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
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
