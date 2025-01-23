class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.3.0.tar.gz"
  mirror "http://miniupnp.free.fr/files/miniupnpc-2.3.0.tar.gz"
  sha256 "025c9ab95677f02a69bc64ac0a747f07e02ba99cf797bc679a5a552fed8d990c"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b53196f6bf5c2d28576b5641ef81ab2dde16a6c1194d7493d4239cac7683c3ce"
    sha256 cellar: :any,                 arm64_sonoma:  "627cca7ad456c05525b713e7672af9fcf61ae9795de70195447338927c432e5a"
    sha256 cellar: :any,                 arm64_ventura: "aabd467d18967c700a6fca90dafe9c660d362f9e59999119e70c2f5747e9c90f"
    sha256 cellar: :any,                 sonoma:        "f10bc722814029cbfed7e0561a93f80d492d5a8829f3a2f361bd0986b105bf06"
    sha256 cellar: :any,                 ventura:       "689112816ace0060ef2f9966c8614d2fd5a36901916b0bd91a37c41060224ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87d9003fd6b19c5666943c03136f754847fe0542a7350325c7ecd633e712fe38"
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
