class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 "15cb157add4120367495039e7afd8a14f7a3177a5bae0d90f9a1a19ae15f47da" => :mojave
    sha256 "6fb4502bafeefe1e2a92f3a0b2dc16aa246344fe781b2b080d8895ee9f4d631d" => :high_sierra
    sha256 "f2d430dea3a7794c14d865a4ae9426f44254dfc9f84ece48b6699fd64a5305d0" => :sierra
    sha256 "e41a174da5447d3381a8fe39b1740d633c53c5819545ec53878743aad925b6b0" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

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
