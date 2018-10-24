class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://qosient.com/argus/"
  url "https://qosient.com/argus/src/argus-clients-3.0.8.2.tar.gz"
  sha256 "32073a60ddd56ea8407a4d1b134448ff4bcdba0ee7399160c2f801a0aa913bb1"
  revision 2

  bottle do
    cellar :any
    sha256 "36e51aaa7622a2da108c7ad863b52de41c3e0682dfb65b09d1a6e45b3c82db10" => :mojave
    sha256 "c1e2461ae53031164d50a775b5c3f83b0f4155be54fac037b55934d940a631d4" => :high_sierra
    sha256 "e1449092f7f8d2645de4339be67f9c84705f84b6d9fee8277277dbb5c3cd6625" => :sierra
    sha256 "1f9efb0c9ed77f8c546595cfda46c60dcaec81e3c0d01e5a4d7a31595a24f88c" => :el_capitan
  end

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
