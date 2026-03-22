class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.18.3/libupnp-1.18.3.tar.bz2"
  sha256 "076d722e4bb419bd43f0c068033cd3c3a9af67a57b8b191638136c0abdb75100"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "28371fc259373c87305958711063f64956ee423fab4f1a449c180de601e8b4d0"
    sha256 cellar: :any,                 arm64_sequoia: "c4dc4d3303671c7927e58eb2d8bd215e231b000bb18f588d8ba0bf43154c0121"
    sha256 cellar: :any,                 arm64_sonoma:  "61e2e697e673ebebe76eebec3de687822b2ebd09ccaeeaf92a9b5dd27ab16ce1"
    sha256 cellar: :any,                 sonoma:        "53ab693d3be27c63fb9132a730dc392168bf6040727c820b503e1cc8cbb82345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a66af39878e8bb35b412dc47588ada853d9ddcb66b9c5b9470dab8628dce81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2bbbbfd96ea85d98f941087cdcf4688bccf4b20c2534af37689e53ab0d7fc24"
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
