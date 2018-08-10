class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/axel-download-accelerator/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.16.1/axel-2.16.1.tar.gz"
  sha256 "675a8608ffa305b98624a3c2684c84e4696572e3fd7dce6d12e0a9b61d64b67f"

  bottle do
    sha256 "18d458adef55854c33e4be487ce77eaa294fa9b7c8f09bcd3aff68cea063c2ab" => :high_sierra
    sha256 "2ed9747656442072e684c56a6354fcbfd1179b01cd0873cc77760a6e64270662" => :sierra
    sha256 "10257917ed87edf070064ad51dac4a3685415f969a6999a5a55938aab355f584" => :el_capitan
  end

  head do
    url "https://github.com/eribertomota/axel.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
