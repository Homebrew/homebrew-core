class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.12/bind-9.18.12.tar.xz"
  sha256 "47766bb7b063aabbad054386b190aa7f6c14524427afd427c30ec426512027e7"
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
    sha256 arm64_ventura:  "4af825b967b6b6712b7073845613d72279a41d8a1ddef55b21592697e1111bac"
    sha256 arm64_monterey: "2bfc74ece9777b535d2ec0a44c892d102c63230dfe1f34e0a15186ee8d76bd2e"
    sha256 arm64_big_sur:  "28ea0ecfb461ef53c9ec36ae3d78a67407c679d2130a9a173e91fb3dbfbcf035"
    sha256 ventura:        "51ddf86fd55f2fae31e4326afdd2baef4f39b951f7a49f89d3611ddcca0d6e6b"
    sha256 monterey:       "ea23a980e54db10d13c52fcae92dc436aff929912cecb368d2162c38c845f7d9"
    sha256 big_sur:        "f3afcfaab5a1dc52b75fedce12c3f1546e799ccbb085db2ecf17d25642379254"
    sha256 x86_64_linux:   "1bb21990f4a46acbdb95944a3288095d47d55d4c8c80bf389d1e9facb0bc70fc"
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
