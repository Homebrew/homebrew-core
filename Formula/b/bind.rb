class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.20.2/bind-9.20.2.tar.xz"
  sha256 "a31dba2aaa1b371902dd0474eb3963f47b7ffed2bd9ece7da4834e23210d6067"
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
    sha256 arm64_sequoia: "f99dc01b13988ee07cf117cf7ac97aeddfcde46a1675eb4f3bcfb8161d5b776e"
    sha256 arm64_sonoma:  "f63b9bc23f213919ba7d374ee389ff8393c88018b3c524a0eb9782cbaec04cd6"
    sha256 arm64_ventura: "d54700c178c370cec24c2aa2ec01608afd69b860846f8fcb6e9295c2fdba0213"
    sha256 sonoma:        "b4b427e5fb88aa60e0b655c1b2d6c997449ee0ef1db7e338ae6f58af43dfbc49"
    sha256 ventura:       "94d19809ddd3a4cc1d335a10d038ba8725a8b0781d95c874fdacda183d5e6258"
    sha256 x86_64_linux:  "72cb706ac5f101d3e57594637179a95617482d0a652dfcf9478bf9ac8acdb741"
  end

  depends_on "pkg-config" => :build

  depends_on "jemalloc"
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "userspace-rcu"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libcap"
  end

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
