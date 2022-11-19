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
    sha256 arm64_ventura:  "5e7a6e2e590c19a687aad9b217c2d987751ec945ce667f0edc2b889022b0c2e7"
    sha256 arm64_monterey: "47f658f0ebf02ee8e31eee9ed1bd95309816866b76286c49dec37f03a935248b"
    sha256 arm64_big_sur:  "f5bc92fe3851ff3847ca64196db9ed5968c29542e032b32524d510e746504c47"
    sha256 ventura:        "c09cc95f6ed895c104f275aaab252b402fdf064d7fd43f4f498c53d3c4ff5b62"
    sha256 monterey:       "a7e50c40847023932279096047a2ceb3aa170d3f5b9a8a44c00b3c8e479f3acb"
    sha256 big_sur:        "3a01235a7915353bbd5701d00e67eb0df782a47689f17993d544f2a51c867c94"
    sha256 catalina:       "6204de414f9a25229c051b5feac73b5834e0d9bf6b5cc158b26c30ecc9630479"
    sha256 x86_64_linux:   "b42f82b55d55aa492a454492c6099fd7b22f44305de9fcd6cead321ffd85e679"
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
