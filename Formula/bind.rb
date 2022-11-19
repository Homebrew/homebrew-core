class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.9/bind-9.18.9.tar.xz"
  sha256 "6a9665998d568604460df0918fc8ccfad7d29388d4d842560c056cc211cbb243"
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
    sha256 arm64_ventura:  "31c535e832a2f4dbe73df6e003354a5f8b4b0f9d28b0090f54378723d1a6f287"
    sha256 arm64_monterey: "83e591050160d6f7990f4e7866b359d7b1debaf1867c7b5cabdddb3592aefaf9"
    sha256 arm64_big_sur:  "7defcc05b6173c1b8248c93557cee07467ec9bbfe3c1630495adac35dbb499f4"
    sha256 ventura:        "764ff0b0491d01fb75c372366d3a2fdc9769862f6b6c0fdd1bf98374cbef2e36"
    sha256 monterey:       "dc0572b8a3121e858a017f0240a21b4d1640a6adbadaf4f839ff1b5f00a73370"
    sha256 big_sur:        "27fe4d293bd6ad85d5ccacd081bb4fba906b974fb67b250bc2bb9c93471e53d6"
    sha256 catalina:       "d327649427cec425208790551383a838a0d9444debd26acb8f85694c157d54f0"
    sha256 x86_64_linux:   "33b9eb56079e6046654929e0c553ccda3c936d9627ffdab76ac3748695f72951"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

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
