class Ntp < Formula
  desc "Network Time Protocol (NTP) Distribution"
  homepage "https://www.ntp.org"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p17.tar.gz"
  version "4.2.8p17"
  sha256 "103dd272e6a66c5b8df07dce5e9a02555fcd6f1397bdfb782237328e89d3a866"
  license all_of: ["BSD-2-Clause", "NTP"]

  livecheck do
    url "https://www.ntp.org/downloads/"
    regex(/href=.*?ntp[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "595cf492f8b44f1c0242c1a96d22fc1bb480bcca46214b2cabfc4abeee18e214"
    sha256 cellar: :any,                 arm64_monterey: "ce1a6fdd2f848d4a3e3ae476e83c7044152842d7789f40d93b3a30f908b1ace1"
    sha256 cellar: :any,                 arm64_big_sur:  "3f4b22c9f68db9358ca5f59f5e39de2fd210d84f32d8bc9898eeb21d293ea515"
    sha256 cellar: :any,                 ventura:        "3bedbc6902c73ccdb3b5ef079eb1b516915d1e71459951a754dddc219cc1c274"
    sha256 cellar: :any,                 monterey:       "2214bc64b8c914045d7e53560950a6077e346aae0e37ca0f0a49b53b1f0e6d05"
    sha256 cellar: :any,                 big_sur:        "b84d7ec398dcc1995df3cd14f46190ec9bb483ff62421e1dd36eaad5d28c6b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce46dc09e4e56d4b90fa32a14ac29a279515b1aff1be3fab9c66aabb5586efb"
  end

  depends_on "openssl@3"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssl-libdir=#{Formula["openssl@3"].lib}
      --with-openssl-incdir=#{Formula["openssl@3"].include}
      --with-net-snmp-config=no
    ]

    system "./configure", *args
    ldflags = "-lresolv"
    ldflags = "#{ldflags} -undefined dynamic_lookup" if OS.mac?
    system "make", "install", "LDADD_LIBNTP=#{ldflags}"
  end

  test do
    # On Linux all binaries are installed in bin, while on macOS they are split between bin and sbin.
    ntpdate_bin = OS.mac? ? sbin/"ntpdate" : bin/"ntpdate"
    assert_match "step time server ", shell_output("#{ntpdate_bin} -bq pool.ntp.org")
  end
end
