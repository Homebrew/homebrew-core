class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.18/bind-9.18.18.tar.xz"
  sha256 "d735cdc127a6c5709bde475b5bf16fa2133f36fdba202f7c3c37d134e5192160"
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
    sha256 arm64_ventura:  "f011368380aa7f83d5c62b7112112a934430abc81768ee38fa4145a84d9f2381"
    sha256 arm64_monterey: "a1d7d73d7cbb54da51c2c471235de4d2dde663ed997368253f573678f0b57328"
    sha256 arm64_big_sur:  "80a6b549100f9e41f61c6ee7a5c09df1faaaa5cfffb60f90c1e664eed394ea40"
    sha256 ventura:        "9547684172b5dc18289bc31a1a1ecf3d7e99e428b59c5d746d3b56fde09b0fe8"
    sha256 monterey:       "b00d74889e212fdf5deb41efc9c4b73acdb5fe3ebecafebdb046c315c9bab480"
    sha256 big_sur:        "56d6441a7f4e21343311e109ff5825915d334e5ce0d2d03d87c264677724d334"
    sha256 x86_64_linux:   "64eb54192ee90fb41af7d481eba03f6e5607b2edde8d5936443b279ea6d62cdc"
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
