class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.14/bind-9.18.14.tar.xz"
  sha256 "9ae12edf6ac3c430b33ecd1a7c0c0c60875d255185eb87850fa9a5e794a64a09"
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
    sha256 arm64_ventura:  "f6abb11efa8ce2aaec37e1dadedf409a59beb4c0bd6387700ccb8eab1e936c3c"
    sha256 arm64_monterey: "9519c9556c79d8baf4083f63bb77c18fc183b69de166905e6f603adc3aa47876"
    sha256 arm64_big_sur:  "ac112c63eb5a27c3e859f7409c7f383524d8c5817d74ade35bf9f18362bcb93c"
    sha256 ventura:        "99c9ec6c76c04dcd9efdca43dda0ab44b1963c5bb46786b111a1fd6dca5f2fdf"
    sha256 monterey:       "1a16fd4c9eb3f6e13da5a770bdb420a41fc06fe301a52e9331ffd2fbd30988e9"
    sha256 big_sur:        "71764294e8f4a0c3eec34eb4ed21e217d68ae44b8ddf3c2840c45f3f50e903e2"
    sha256 x86_64_linux:   "6e5f224fd0f0e1bdea7793745c2fbae73155a1f060e92687042b61712eab452c"
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
