class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.8.tar.gz"
  mirror "http://miniupnp.free.fr/files/miniupnpc-2.2.8.tar.gz"
  sha256 "05b929679091b9921b6b6c1f25e39e4c8d1f4d46c8feb55a412aa697aee03a93"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2efd6e133d5d0586e556ed15ab02462bddc31d13ba137d6a93635f8a3c6dbc59"
    sha256 cellar: :any,                 arm64_sonoma:   "c47187eabc3f3e849b3262808f11b4ffbf468550cd33cae212d164a6c3440e84"
    sha256 cellar: :any,                 arm64_ventura:  "cf2e402ed211b5d334a8755eebb219f109731018cc51640488f712fc398ba12b"
    sha256 cellar: :any,                 arm64_monterey: "c009ce82977e631c4f2a5fed0bb314c0b80c03b2fc6ddbdd4df4d376e44a1951"
    sha256 cellar: :any,                 sonoma:         "b74f633bf9205c93d9ed1d6bfaa8df9fce6f57895d58780896864b1ba57ec905"
    sha256 cellar: :any,                 ventura:        "34b1c1b24de7bbb5a8ec496f8977374b076895096bbb3b3329725a8aa5a2e3fa"
    sha256 cellar: :any,                 monterey:       "ab79c3db607af5952496421cdf300b654d622969f75d15bcbd0d29294d8a9ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a9a806d9a54469f4cf6ed3d2d130614437564392ab0ee3c7af96c00e6c6565c"
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
