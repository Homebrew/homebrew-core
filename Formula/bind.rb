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
    sha256 arm64_ventura:  "a8338d8715c129fd3e83ecf865f64787a895f2727e8009f9b80bf4a456a0c190"
    sha256 arm64_monterey: "39c82f9b96a451fc71104b32e02a5627b1969ac80cdace1f54af83fff28618f7"
    sha256 arm64_big_sur:  "0e08d44b2ad69cee34c2a82c4c64294fc31b3767a0261edfd9b4005409108d60"
    sha256 ventura:        "dd33736c7adbaaca30d44b49f79d16aabef4059857f865343abe434f0f01bf93"
    sha256 monterey:       "c2c6f2075b72d38eff489cd5502a72f0b75f702a9225df23a7d7947b62d41fb9"
    sha256 big_sur:        "27b48075f5e0d682e09cb453bc34d47e2a1ef8e04ca98615eec1527dc6398935"
    sha256 x86_64_linux:   "4fac88ef7928ca2007b6f1a68620dc82898cf1317750efc9815ddf8f8bf621f1"
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
