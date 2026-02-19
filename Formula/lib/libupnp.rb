class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.18.0/libupnp-1.18.0.tar.bz2"
  sha256 "addda30208adcea72d38e25e36b1c9a1239333e23294597db424f9ce825af60f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00930efbbaac10e6f9b7a3e0510c81503c85207eb1c5c680c1218038474e01d3"
    sha256 cellar: :any,                 arm64_sequoia: "a08dba898bc6e1600ce6afd044253b7b09e74fef99e784dbe1d1e51fc78336c9"
    sha256 cellar: :any,                 arm64_sonoma:  "b5e588d93f0c1afab09f0728ae0b8de8338ce426033b966bbae56169d4c849ce"
    sha256 cellar: :any,                 sonoma:        "43ad30d4f65ee7213ca17c278c31c7bca1067171df47741bafca185be206fcda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "930b9aa2de93b28c089cf3d31c79ee745aed44850bc4297d660695fb40547da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5ab2fa1639006bda4a3a3e51874daf392dc9452f3a92da23c5854b88a6b6e23"
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
