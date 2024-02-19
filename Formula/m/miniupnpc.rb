class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.6.tar.gz"
  sha256 "37fcd91953508c3e62d6964bb8ffbc5d47f3e13481fa54e6214fcc68704c66f1"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "02a81c9c170c97effbcae5b55f8b2a385efad63b971f504b4526fc609e1c6ed5"
    sha256 cellar: :any,                 arm64_ventura:  "2bda37195ccbaa7d59c3232ad2e3eff64fda54635fd1447b145f636e7678745f"
    sha256 cellar: :any,                 arm64_monterey: "329d8d48af0c01f50dfaaa061f05d4c50a510f8b1cd78a713ea6289e547053d4"
    sha256 cellar: :any,                 sonoma:         "9a5f84d7bbc7fb3b0e3a09bf3f776425aecf84f49261def4b904d752d0bcba95"
    sha256 cellar: :any,                 ventura:        "2d185bc3955d99d1b8050a3c1b15c363c7d3d9782c3c46adf06f05bcf08b831e"
    sha256 cellar: :any,                 monterey:       "2621a3091630fe71fddc538948a93b6758d6635ee7594c89f0e121e6a2a45256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0da03bf3a4b1bcd7152393a9a3bd7ebdbdefa4a7d68b250b0182f4aca7492f9"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
