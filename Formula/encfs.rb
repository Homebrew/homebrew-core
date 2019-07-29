class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  revision 2
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 "b520ccb48e5c8f9652c9a297123eb174308b55114007de33c5fb90b2a9b2e4b4" => :mojave
    sha256 "45dcc64c557931df5c0c288de0a0417fc7a6689e203b496423ef6e4bcff54e58" => :high_sierra
    sha256 "3b7cc4337ea5f9f1b5e4ab54dd60373e943a94ac95bf7c8aa0af059a1561f364" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl"
  depends_on :osxfuse

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
