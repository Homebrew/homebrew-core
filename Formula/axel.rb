class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.15.tar.gz"
  sha256 "0e223f18954e4c6c34b882a474c526b9c7d107168220c2f3892598248236a172"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "9a113a4e26408726833f2b0b84cd420944d633b4bebba1982ee96a65176bccdf" => :mojave
    sha256 "18d458adef55854c33e4be487ce77eaa294fa9b7c8f09bcd3aff68cea063c2ab" => :high_sierra
    sha256 "2ed9747656442072e684c56a6354fcbfd1179b01cd0873cc77760a6e64270662" => :sierra
    sha256 "10257917ed87edf070064ad51dac4a3685415f969a6999a5a55938aab355f584" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./autogen.sh"
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
