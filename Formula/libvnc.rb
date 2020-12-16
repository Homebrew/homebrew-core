class Libvnc < Formula
  desc "Cross-platform C libraries for easy implementation of VNC server or client"
  homepage "https://libvnc.github.io/"
  url "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-0.9.13.tar.gz"
  sha256 "0ae5bb9175dc0a602fe85c1cf591ac47ee5247b87f2bf164c16b05f87cbfa81a"
  license "GPL-2.0-only"
  head "https://github.com/LibVNC/libvncserver.git"

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "lzo"
  depends_on "openssl@1.1"
  depends_on "sdl2"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=ON"
    args << "-DWITH_GCRYPT=OFF"
    args << "-DWITH_GNUTLS=OFF"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"examples/example.c",
     "-L#{lib}", "-lvncserver"
  end
end
