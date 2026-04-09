class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.18.4/libupnp-1.18.4.tar.bz2"
  sha256 "158b798734412ac3406a950949dc9b0739cea8c315eb63aa760769d25621ec39"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50cfa2bd223351ba0170fbbc02fea0b7223132279c7a9077b75d2cd82c29a4fd"
    sha256 cellar: :any,                 arm64_sequoia: "40e5bc6d5a845d9363e9369e7604b2f9806012202426f523ee80fdbe83b3a9f2"
    sha256 cellar: :any,                 arm64_sonoma:  "d081b193b3a10f4a3da27d83d4794166425b8449b46631103a8cbdd18447e65e"
    sha256 cellar: :any,                 sonoma:        "9a1473138b1a25848f4519a577c17aa073060b9497318e244aeffd69d8a62e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e993fa1421b04db685b4985120216fd86ffca2a82eaea815d17d02cc44d1d29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a716924d2d93e7c1e00197593f38a3977bf6da1de3c3bf5f46400bfe69ebc291"
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
