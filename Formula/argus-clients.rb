class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://qosient.com/argus/"
  url "https://qosient.com/argus/src/argus-clients-3.0.8.2.tar.gz"
  sha256 "32073a60ddd56ea8407a4d1b134448ff4bcdba0ee7399160c2f801a0aa913bb1"
  revision 4

  bottle do
    cellar :any
    sha256 "bc1e31b61274fd4fcd6f5e70e2963e21636b510892ce6e88294fea3fecba3edb" => :mojave
    sha256 "b98135c7226010cecbbe7ccd23b1eb9a05cc0d517c531a0189b1659fa3d44d2e" => :high_sierra
    sha256 "52964969252de58e4561866a362ff62456c7da129bd56a8c4a270adb4c16682d" => :sierra
  end

  depends_on "geoip"
  depends_on "readline"
  depends_on "rrdtool"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Ra Version #{version}", shell_output("#{bin}/ra -h", 1)
  end
end
