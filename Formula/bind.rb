class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.1/bind-9.18.1.tar.xz"
  sha256 "57c7afd871694d615cb4defb1c1bd6ed023350943d7458414db8d493ef560427"
  license "MPL-2.0"
  revision 1
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7bea41b940a9685654573fede45cdd3beff80933041ac1dfaa896465e8d18fc7"
    sha256 arm64_big_sur:  "e4aa1c250aca44c7b52456ed8fcd703e3893a4870473d4a675c50bed0619e948"
    sha256 monterey:       "247f68f79dc6781aa9614a7655f3ad17ba3f02e0b6116d7a81e8027b043e1138"
    sha256 big_sur:        "8b63b979d6aec80f240ecea263f48c1d3315a1e6db9f2ee655aabecc0ef7ea65"
    sha256 catalina:       "863939241b4b36ab4c4fca4c0a4f1f240136471849619a008a187d0ee975dce4"
    sha256 x86_64_linux:   "a33df0dd6e907191dbe3c8cfe6470d42734f38375b314751281e73643b7809cd"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    # Fix "configure: error: xml2-config returns badness"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{pkgetc}",
      "--localstatedir=#{var}",
      "--with-json-c",
      "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
      "--with-libjson=#{Formula["json-c"].opt_prefix}",
      "--without-lmdb",
      "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
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
