class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.15/bind-9.18.15.tar.xz"
  sha256 "28ae8db14862801bc2bd4fd820db00667d3f1ff9ae9cc2d06a0ef7810fed7a4e"
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
    sha256 arm64_ventura:  "c4c2907fa1740fd2a8e6993b6ae266666b83b37e709868bfbf1c6fe447451a59"
    sha256 arm64_monterey: "50734380ee2b1aaa24a96c1f754590455a279746ef198adb8926b8baebca1e72"
    sha256 arm64_big_sur:  "3c5dbe0be8d34e832de2a04a74fd89086156b2e948d931444db36265ec385d1d"
    sha256 ventura:        "9c79654135f7a4cce55301685ede280eddd98483072c313a50c3ce1e8c2d21f5"
    sha256 monterey:       "e578ebd6ae7a9a275dabb9929a43226a1ba972c7793d215d8ed663595146680b"
    sha256 big_sur:        "b98ec615ad66aaa96704ea4875cb0140c4df3939b6618a8701ad3311fb9985c8"
    sha256 x86_64_linux:   "9fe3fcb1110cc787808bc4591665e545d3fdfb3eedd2523ce7c3fb60757f0439"
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
