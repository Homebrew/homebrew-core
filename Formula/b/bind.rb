class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.27/bind-9.18.27.tar.xz"
  sha256 "ea3f3d8cfa2f6ae78c8722751d008f54bc17a3aed2be3f7399eb7bf5f4cda8f1"
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
    sha256 arm64_sonoma:   "8c02f8532bef58ced2ccf0786104152c1c188b9e60276551ce5ebd4d6ea3ac39"
    sha256 arm64_ventura:  "860a251e16395909b87544254670300636b9e148dbeb24ddf0b03f50452c4680"
    sha256 arm64_monterey: "b4f9f604699761ffcfb211b0cfc992712358e872db2880f68f365785131134fd"
    sha256 sonoma:         "8f00c260cb14f5ebb5994c3b3e3d134b6434782f2b36cb58c35bbbe415ff4976"
    sha256 ventura:        "2ef3c4dc6ebc29c723e234e86b12ff687a34547874f77c1bf4ba75d743009304"
    sha256 monterey:       "131da16a3461905a43f6f2bd1563bde5383f5a7780c1bd2dbe37d1134c443a03"
    sha256 x86_64_linux:   "fd06d75b34091bc2456f1eb3742c84a1b8bea2c9edc1e1539e173c278e8d48c5"
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
