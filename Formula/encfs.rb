class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  revision 1
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 "fc9ed25a624d2605345f42cf88a64ef68827d62f0d69ec178afe2aa9eeb91dfb" => :mojave
    sha256 "852027d9c80ef4e87f6d11e3523690c9901b12a3e0f657fef3ef35ad23b6a0ef" => :high_sierra
    sha256 "b5bf937680319c60a4d15bcefa7556009129351d7a8f9a3a5bf97475167e958d" => :sierra
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
