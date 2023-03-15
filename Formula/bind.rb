class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.13/bind-9.18.13.tar.xz"
  sha256 "3b06b6390c1012dd3956b1479c73b2097c0b22207817e2e8aae352fd20e578c7"
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
    sha256 arm64_ventura:  "271e4e8b012e7d104cbfa51ca0651147909c6286206130af1fb5dcf94d47fd5c"
    sha256 arm64_monterey: "65c099903768cdf44bb1eea1384586f6bb5238f850c9bfea13071de193c341e0"
    sha256 arm64_big_sur:  "12d68e9d3852b4fddc96e7a5e095bae62f1e8b433b688111fac0fcf8b6d255d2"
    sha256 ventura:        "590efd451ff0fa0fd9d7b7a6f17f6191fecd753f6bb0a3aed7b1530ed6eb4bdc"
    sha256 monterey:       "ab12926626284d7bfa46104229b19807c652883da9a5353223afb033238c419e"
    sha256 big_sur:        "48adc80b96ce62e0ffebc808992ca213fb47ec9660c57c39e9d4b150e88105a2"
    sha256 x86_64_linux:   "5f30ba1f41e19c28d50d728ff34b6be8008952c62c2b6b150f1f1964a41fc470"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{pkgetc}",
      "--localstatedir=#{var}",
      "--with-json-c",
      "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
      "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
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

  service do
    run [opt_sbin/"named", "-f", "-L", var/"log/named/named.log"]
    require_root true
  end

  test do
    system bin/"dig", "-v"
    system bin/"dig", "brew.sh"
    system bin/"dig", "ü.cl"
  end
end
