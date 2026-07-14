class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.0.3/libupnp-22.0.3.tar.bz2"
  sha256 "8d7866015e200efa7c29a47f220225e21536619288f75b2d16b37bdbd681918e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "87b39b9c80a49ae61e8176ccea3d588a5190cb6c32cc7607b3a01812ecdaa50a"
    sha256 cellar: :any, arm64_sequoia: "2410c851735b65c032baf1874624a58bab632582fd75d7ea73ac7562e82219de"
    sha256 cellar: :any, arm64_sonoma:  "d573ee0380c0b6d801da2831db8d660e26f2886ff227e7e0764c27fc71188dfe"
    sha256 cellar: :any, sonoma:        "b8241aedaca02f45e6ee2e8e7937ea4694ae99d6aa8bbba9c7303d8336b688c1"
    sha256 cellar: :any, arm64_linux:   "a83866dcb0cbea7253a313f8c70bc0115fc7c0d0ed31e25ec826a94f3ed28011"
    sha256 cellar: :any, x86_64_linux:  "ad43292c09cd1335de976363ea15498691096a28080232a43b74ba1393a270de"
  end

  depends_on "cmake" => :build

  def install
    # https://github.com/llvm/llvm-project/issues/65557
    if OS.mac? && DevelopmentTools.clang_build_version < 1700
      inreplace "upnp/src/genlib/miniserver/miniserver.c", "switch (gMServState)",
                                                           "switch ((MiniServerState)gMServState)"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "upnp/test/test_init.c"
  end

  test do
    system ENV.cc, pkgshare/"test_init.c", "-o", "test", "-I#{include}/upnp", "-L#{lib}", "-lupnp"
    output = shell_output("./test")
    assert_match "UPNP_VERSION_STRING = \"#{version}\"", output
    assert_match "UPnP Initialized OK", output
  end
end
