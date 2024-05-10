class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.26/bind-9.18.26.tar.xz"
  sha256 "75ffee52731e9604c849b658df29e927f1c4f01d5a71ea3ebcbeb63702cb6651"
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
    sha256 arm64_sonoma:   "d2aae7397baff0e2f6c7e23acab7e66a703fb20cbc400c9c0c8aa6053f25b060"
    sha256 arm64_ventura:  "07a1ff47fd1d557f4511c7d1f53eef2a80a3f9e8f1f33ce08ffb092063f1015e"
    sha256 arm64_monterey: "1e4c5f7005b85a214455a9e15e8fc4037578dae728bfb2ab42020bee308f319e"
    sha256 sonoma:         "4a7f9ca14b7e5371bae83975ad3b99754d9dc72d7b3f95b9ceb9a16beacc8256"
    sha256 ventura:        "8fa5bebf43c23099644b7a7831bde3c8c7068a86bd0d9079fe1118e9f231c79f"
    sha256 monterey:       "1268074f1276468f8a8d25f53edf9883626da9eba1e644093948a55b444f8baa"
    sha256 x86_64_linux:   "b3d8594bb7bbacf7156d9f67385943c5083914a0cab4ceaa53f58c30b0f5cc7f"
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
