class Libvnc < Formula
  desc "Cross-platform C libraries for easy implementation of VNC server or client"
  homepage "https://libvnc.github.io/"
  url "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-0.9.13.tar.gz"
  sha256 "0ae5bb9175dc0a602fe85c1cf591ac47ee5247b87f2bf164c16b05f87cbfa81a"
  license "GPL-2.0-only"
  head "https://github.com/LibVNC/libvncserver.git"

  livecheck do
    formula "libvncserver"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bed86692d7831c43a601f2c0a1eb26aed08540bec111db9ad356068e7b1a7b2f"
    sha256 cellar: :any,                 arm64_big_sur:  "20c74a915bd00103a38d68a25a24aa700b36f4b0f1882ce399f1ad45b9b4a3c5"
    sha256 cellar: :any,                 monterey:       "f6ea03526482d885c35f8d82190daeadf411053c0e72fb7727180e0ed6751b11"
    sha256 cellar: :any,                 big_sur:        "ea5e78dfaf457a33519debdc579dfd868f6503ef93b526d0f57fcab73997f298"
    sha256 cellar: :any,                 catalina:       "908c0d7fa104abe781cc67b0a9ebff7e2208cf3cbfb4b7acd770d3d92bb14c9d"
    sha256 cellar: :any,                 mojave:         "4744d5940eb9095e9d7ec8a731c8f611a252e5548237d3d338a2334766b38825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a38e3225e47344136ae3e0e51c0f1875d25ad7f7b49f319c87383262f842938"
  end

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
