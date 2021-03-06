class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.2.tar.gz"
  sha256 "888fb0976ba61518276fe1eda988589c700a3f2a69d71089260d75562afd3687"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "fcebf3eb8eb91936643c693155de21d72c697091ffa3dcc7b490dec235719dda"
    sha256 cellar: :any, big_sur:       "9fab3b162f13e509a2f5dd1858a91374961898808f28aeb4153f6294b9f1a2b4"
    sha256 cellar: :any, catalina:      "fd72b75df14dc0a23f566031fbddef7110acf0e90b34092ef09ef62fa74a6117"
    sha256 cellar: :any, mojave:        "78f72e56f2edb01fb2d7949836050cca173fe9c342b602c7b9c3a8dc31693849"
    sha256 cellar: :any, high_sierra:   "ac7dcda27fedebab8e8c47ce08c74283626a0169b646a09b34de5bd91b673e1a"
  end

  conflicts_with "wownero", because: "wownero ships its own copy of miniupnpc"

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
