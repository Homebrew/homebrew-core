class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-2.0.2/libupnp-2.0.2.tar.bz2"
  sha256 "4a79edb812397e38b85bb95344a7fda4a17f54fbf53fdb828cc23ddb7e695f77"
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

  def install
    # https://github.com/llvm/llvm-project/issues/65557
    if OS.mac? && DevelopmentTools.clang_build_version < 1700
      inreplace "upnp/src/genlib/miniserver/miniserver.c", "switch (gMServState)",
                                                           "switch ((MiniServerState)gMServState)"
    end

    system "./configure", "--enable-ipv6", *std_configure_args
    system "make", "install"
    pkgshare.install "upnp/test/test_init.c"
  end

  test do
    system ENV.cc, pkgshare/"test_init.c", "-o", "test", "-I#{include}/upnp", "-L#{lib}", "-lupnp"
    output = shell_output("./test")
    assert_match "UPNP_VERSION_STRING = \"#{version}\"", output
    assert_match "UPnP Initialized OK", output
  end
end
