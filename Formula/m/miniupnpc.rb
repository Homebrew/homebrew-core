class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.3.2.tar.gz"
  mirror "http://miniupnp.free.fr/files/miniupnpc-2.3.2.tar.gz"
  sha256 "985de16d2e5449c3ba0d3663a0c76cb2bff82472a0eb7a306107d93f44586ffe"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4fdfdf22605ea11dfd6e866d3242bb664a53cc3b7eea62bfb423058b9b9b3cf"
    sha256 cellar: :any,                 arm64_sonoma:  "bb9ac898c244e04860ec28b0a3a489db6dac386b486eaa8de62099c11483bba2"
    sha256 cellar: :any,                 arm64_ventura: "bd2a1273aff1fbf36a9075705a9015aebe5b73442ea0e2a341d719ad3c415620"
    sha256 cellar: :any,                 sonoma:        "9da80d7aaa922c85494958a198c9143418e9f2fe8de15f1513c5e5227408c8c1"
    sha256 cellar: :any,                 ventura:       "28659765506db23ae9af44a4cde57a4cc80b2a2e74287e718e4e7550546c6b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c497462f5aab9c34fa69be465e3a178842091883f6bf36933652d78ff28a7873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac5988243371ce9002e68ec9132dbe93b54ba905e307b6950a110ae1504fa931"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    # `No IGD UPnP Device` on CI
    output = shell_output("#{bin}/upnpc -l 2>&1", 1)
    assert_match "No IGD UPnP Device found on the network !", output

    output = shell_output("#{bin}/upnpc --help 2>&1")
    assert_match version.to_s, output
  end
end
