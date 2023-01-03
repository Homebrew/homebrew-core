class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.10/bind-9.18.10.tar.xz"
  sha256 "f415a92feb62568b50854a063cb231e257351f8672186d0ab031a49b3de2cac6"
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
    sha256 arm64_ventura:  "43eba3418b76653aa170858f63733d45c9930c1e4e72799086cc56b632e9413f"
    sha256 arm64_monterey: "25ea6590c38696b05bdd980280c9d5ed4e4d799779debc86a57d7676516b8028"
    sha256 arm64_big_sur:  "95c1ca6f56df52158bdfce7352aa9d9c2a900eaf5cacd688e8ce5246d95941fc"
    sha256 ventura:        "c85ab574088ce132580471e8479002b36c6d0c654edd8566d67e27acb4677019"
    sha256 monterey:       "58e9b01cf604962e99d81cdab712e9b1d2075854f796ad2699043d711a32efc4"
    sha256 big_sur:        "cccac27cd01b5c834ed6606d6b601ebf0f4a514c13aee74a3f9fc59581ae8437"
    sha256 x86_64_linux:   "3f9328beae0e3dfb1cbc4fecb3abef647da636c025990f8e2d0b44a34071a913"
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
