class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.14.tar.gz"
  sha256 "84306f4bc4f665459593471be14ee2c18af1c932fc90a1b6a3a0b854dae67be4"

  bottle do
    cellar :any_skip_relocation
    sha256 "be0d8c1322fd71526a645a5de6e99e98fbe902381c8461d599b2cab296efe57f" => :mojave
    sha256 "6cac34a093eef64232de52d8a8bbb73df044cb0932f2904885eebb259e283629" => :high_sierra
    sha256 "a99efba435b3c1cfd0fc99414fa529fa47d511ce64d031f575ee6eeddb85d6a6" => :sierra
    sha256 "9cb1ce12d1e70adf3bb6c7114079253155c4a494682be0c3ac9ef8c0390da226" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
