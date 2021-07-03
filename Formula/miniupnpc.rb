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
    sha256 cellar: :any, arm64_big_sur: "bb414f85009c261710a00d438afdd3270f5c38039c02992eae612a8fa71442d0"
    sha256 cellar: :any, big_sur:       "8493cfd956df3566d8025042e44d4cf60995ff0a7a1c1cce4d6ef388e20c0b58"
    sha256 cellar: :any, catalina:      "bde7e04d31203a1a5b1c89d167c8cc4e7962ba4beaa351f1edffe47e03561223"
    sha256 cellar: :any, mojave:        "f9d73d4839a56b72369a506c52676b055a584135f9ec94d6ecd9ebb1e6407f9e"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
