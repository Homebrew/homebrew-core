class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p10.tar.gz"
  version "4.2.8p10"
  sha256 "ddd2366e64219b9efa0f7438e06800d0db394ac5c88e13c17b70d0dcdf99b99f"

  devel do
    url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-dev/ntp-dev-4.3.93.tar.gz"
    sha256 "a07e73d7a3ff139bba33ee4b1110d5f3f4567465505d6317c9b50eefb9720c42"
  end

  head do
    ## The git repo is broken/ancient, per
    ## https://github.com/ntp-project/ntp/issues/17 but the others
    ## aren't much better.
    ##
    ## bk://bk.ntp.org/ntp-dev
    ## (4.3.93) 2016/06/02 Released by Harlan Stenn <stenn@ntp.org>

    # Unsupported syntax?: depends_on cask: "bitkeeper"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  option "with-net-snmp", "Build net-snmp support"

  depends_on "openssl"
  depends_on "net-snmp" => :optional

  def install
    system "./bootstrap" if build.head?

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-openssl-libdir=#{Formula["openssl"].lib}",
      "--with-openssl-incdir=#{Formula["openssl"].include}",
    ]
    if build.with?("net-snmp")
      args << "-with-net-snmp-config"
    else
      args << "-with-net-snmp-config=no"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "step time server ", shell_output("#{sbin}/ntpdate -bq pool.ntp.org")
  end
end
