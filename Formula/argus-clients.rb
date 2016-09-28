class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "http://qosient.com/argus/"
  url "http://qosient.com/argus/src/argus-clients-3.0.8.2.tar.gz"
  sha256 "32073a60ddd56ea8407a4d1b134448ff4bcdba0ee7399160c2f801a0aa913bb1"
  revision 1

  bottle do
    cellar :any
    sha256 "661b94827e7706274bbb9a06b34f43d4d786884a36129a08a89d0e8b66e9b480" => :sierra
    sha256 "a44580978e9c1f808539d82fb6096f063df0f57fa7a0f77bef76658f11007ca8" => :el_capitan
    sha256 "2afdc15edf35307ad7ab8be9db35e64f34216247182286aefbe7173f2c4f9fba" => :yosemite
  end

  depends_on "readline" => :recommended
  depends_on "rrdtool" => :recommended

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
