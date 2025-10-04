class Ntp < Formula
  desc "Network Time Protocol (NTP) Distribution"
  homepage "https://www.ntp.org"
  url "https://downloads.nwtime.org/ntp/4.2.8/ntp-4.2.8p18.tar.gz"
  version "4.2.8p18"
  sha256 "cf84c5f3fb1a295284942624d823fffa634144e096cfc4f9969ac98ef5f468e5"
  license all_of: ["BSD-2-Clause", "NTP"]

  livecheck do
    url "https://downloads.nwtime.org/ntp/"
    regex(/href=.*?ntp[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "67f312e7b755756bb74869269cb8b4fd9e582e6f265be0730c39d541422b54cd"
    sha256 cellar: :any,                 arm64_sequoia:  "991683b9f1c1596bd5b8c518bc94efc07539371b2ef0c3ee49144e2db44d4e8e"
    sha256 cellar: :any,                 arm64_sonoma:   "41bfb9eea202e95df1a7aaaee2884019f7df5f3c0b8be100b4fc09f7ac26cdd1"
    sha256 cellar: :any,                 arm64_ventura:  "7ba3ffa6ba07c07ed7fbe369c179179771936d3c98393f5aec6cbedf7098eafe"
    sha256 cellar: :any,                 arm64_monterey: "e8a0cff26dafc8c15090033a5425ef996c16ff35e7517de4a6dda107a8e0535e"
    sha256 cellar: :any,                 sonoma:         "9128d709ea91a5cea9a64a6c804d2d2c96a5231166ae6479e43343cb6bd781ac"
    sha256 cellar: :any,                 ventura:        "92ddc0b1b103b862bf61a27841c4d1ff4ffcdc415f0f64f8425dd829bc62ee6b"
    sha256 cellar: :any,                 monterey:       "6f8e1ae4e1b385d6be6a447b34cca98566cc24d7ba5bdf9960de5abc2b66b13f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "40bf8bb2e6bd82b46d60e28e3f2c0d65e5a68778560d89a17b6296410358dc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e45f68bdcd6758f869f30271115cbe845d5b9e0d1b72b9429e63624109bc09"
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
