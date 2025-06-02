class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.0.4.tar.gz"
  sha256 "e77512725dedb23b3e8094ca3153fc3ffe51d3c32cd9dd56779480a93625de90"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "a5a83f2592c5b682bf178fab0175c3c6038005821e6c06c7df552df9239f2c39"
    sha256 arm64_sonoma:  "1a74a2f536ed3aa4f3f17bb99771de85ac79a9f8ad08ae48009c3c923ccd3ee2"
    sha256 arm64_ventura: "8c35a0ef94b4b3b4b73e5e28d8b76bf9f5bb07498532ebfc3dd824c481872b79"
    sha256 sonoma:        "01ba2b5a22076ea198c6295fce94d20526507e1009b8669fd65d7425899c6cb4"
    sha256 ventura:       "3271ea0c7e12aa40fc6f5fce6040b99c9f4378f767c8583459ea566af706d72d"
    sha256 arm64_linux:   "b8cdc6fefb55010b75a8377da26135fcf27d7257fac119d2957ac95dece82b2e"
    sha256 x86_64_linux:  "3d3f20a51db6e5642f7c85185081d89d38566b977c4d7c14406e115f34c78183"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    File.write("build-date", time.to_i)
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
