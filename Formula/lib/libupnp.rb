class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.18.5/libupnp-1.18.5.tar.bz2"
  sha256 "fe17522c605752f9f522d8cceab2a4601d75c2b701288a3bdbd9926e1bd9a9a1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30b918b8cd888c12902dbcdd0e319144a9266b8d872ce9b11537cc765aac1128"
    sha256 cellar: :any,                 arm64_sequoia: "529a307bcde0f98cfb407dc7387946793cd95ff4cee2d8c7def931727f29a0ea"
    sha256 cellar: :any,                 arm64_sonoma:  "0ee2e57bba5d8ee8470f510acbf6680b8999d932362e97b9e6ee7d5f3134e94c"
    sha256 cellar: :any,                 sonoma:        "d96216f345b05655855840b6550aed30b122affdfae72ac8f681b19cf9170044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "945e39e6484fd9e2c0d73091e5e5b61873d9b25712e77e0d1183523b9e32c186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b733a51a72820a6d9a3f47b32b4fe718bbfbf43ff3291a38c79e39d1d7e9939"
  end

  def install
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
