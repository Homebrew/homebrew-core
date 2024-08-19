class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.20.0/bind-9.20.0.tar.xz"
  sha256 "cc580998017b51f273964058e8cb3aa5482bc785243dea71e5556ec565a13347"
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
    sha256 arm64_sonoma:   "ab0799198cd7e848ceb055daaae00df733b96c0aac66b6312377f5dac6d56726"
    sha256 arm64_ventura:  "ce64b5a9c3ce68e71c67833d77df665203980973439ed20fc6300f61efc63ff2"
    sha256 arm64_monterey: "57688890ed5bfdcbc4077237f00ab425579f3d597d24ac3e86a2daa063004b7b"
    sha256 sonoma:         "1676001aad44e3e1a077df262a3702675755431b7fbbd8283b7e016ad6f088c4"
    sha256 ventura:        "1301d29fb57919f03f3dcec523716af491a943d6dbf0919be80ee3a03d31e74d"
    sha256 monterey:       "97b517679f22f1ba026a69f182bcb1f48a7cc811a5aa1e64ec3e19bbb04937bd"
    sha256 x86_64_linux:   "b79229207e333af40c9b06acd9c3916acb64560eb4f6c18435fdac818c6ddd1c"
  end

  depends_on "pkg-config" => :build

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
