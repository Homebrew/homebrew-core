class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.2/bind-9.18.2.tar.xz"
  sha256 "2e4b38779bba0a23ee634fdf7c525fd9794c41d692bfd83cda25823a2a3ed969"
  license "MPL-2.0"
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b3166c0dd911a03d58c912c431fde1f908cd8c71fda1cfd6926b18a0c3f880d7"
    sha256 arm64_big_sur:  "00cddc836c5b487701433cd5760e97eb3611f094a20fd360a8e083525c360157"
    sha256 monterey:       "8c7d011a72f5a4bd7f8982f31f7429b246748a5c7b527b63d511b5022ce52a33"
    sha256 big_sur:        "915d8ac26a52b8ee32b3814acb09e4c19eeadbd1fd563159b771aa7321d604e9"
    sha256 catalina:       "40d77a092ea26f90a7175714791a52de5cbcdee78b89a61db26830b84ef60fe1"
    sha256 x86_64_linux:   "867daf07548c0b63963b98e9eb15f371e899899e2f78f4b29e60ffc25518c532"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{pkgetc}",
      "--localstatedir=#{var}",
      "--with-json-c",
      "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
      "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
      "--without-lmdb",
    ]
    args << "--disable-linux-caps" if OS.linux?
    system "./configure", *args

    system "make"
    system "make", "install"

    (buildpath/"named.conf").write named_conf
    system "#{sbin}/rndc-confgen", "-a", "-c", "#{buildpath}/rndc.key"
    pkgetc.install "named.conf", "rndc.key"
  end

  def post_install
    (var/"log/named").mkpath
    (var/"named").mkpath
  end

  def named_conf
    <<~EOS
      logging {
          category default {
              _default_log;
          };
          channel _default_log {
              file "#{var}/log/named/named.log" versions 10 size 1m;
              severity info;
              print-time yes;
          };
      };

      options {
          directory "#{var}/named";
      };
    EOS
  end

  plist_options startup: true

  service do
    run [opt_sbin/"named", "-f", "-L", var/"log/named/named.log"]
  end

  test do
    system bin/"dig", "-v"
    system bin/"dig", "brew.sh"
    system bin/"dig", "ü.cl"
  end
end
