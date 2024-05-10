class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.7.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/m/miniupnpc/miniupnpc_2.2.7.orig.tar.gz"
  sha256 "b0c3a27056840fd0ec9328a5a9bac3dc5e0ec6d2e8733349cf577b0aa1e70ac1"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dff09e9f7b0238cf21478d85f12a31c1785b4c8b34a894c7d9450f799989db61"
    sha256 cellar: :any,                 arm64_ventura:  "12a157bafe9206633cb4837f8c0d2f7d4ac3d5a59c712738af32bc1a3f6126f0"
    sha256 cellar: :any,                 arm64_monterey: "73fcc10ccdc15d29dee4f64e1c1619eb1c9cb3ae11ea0cf9866a7901fe0a9a35"
    sha256 cellar: :any,                 sonoma:         "63c3ca5eab3479b56f18381f2332df2e99ca3bf7708cfdbf7ac26a4a8742c838"
    sha256 cellar: :any,                 ventura:        "1f8cbe269314d11cc7a0d83d4618d983edf26bfaf869810fc4f9289f22aa7004"
    sha256 cellar: :any,                 monterey:       "949a4c9a39f8b2bec9e1904574f3a390aceba622382777982fe323cae51fda1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e06be7f4fcd21887a019cd6f58a99f44a77e951198be8d902e1f32cbe6b9540a"
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
