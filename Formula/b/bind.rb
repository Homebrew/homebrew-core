class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.18.19/bind-9.18.19.tar.xz"
  sha256 "115e09c05439bebade1d272eda08fa88eb3b60129edef690588c87a4d27612cc"
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
    sha256 arm64_sonoma:   "4c63777a9a6b02c0039a4e7a30bc243857aa2eb2b6b03511564e45d8a4acff9a"
    sha256 arm64_ventura:  "3fa17ded26484ce26cc1a177626a6261fd743ee5296b633a493e5477a1391fd0"
    sha256 arm64_monterey: "4d69cad398a9e34b631dff611feaa591ec76859ad61ed9cd5547b8e32848a9b9"
    sha256 arm64_big_sur:  "068666a3a07e259d410854fb723132a42bef4dd9a94a70cc323895af632a4eb1"
    sha256 ventura:        "232a40fe0f6c58b8ae455c740cbb72fa5a1383a6d649d493efc214c7ffc21cf6"
    sha256 monterey:       "85f15935f98df9ffa1b49c7bc19d921b270eeb0096f8b0c7872de8bdef33ed94"
    sha256 big_sur:        "c062018d28a7fb8f9acd7b6323e40ac6704c09845de2f1083dd1a036820de110"
    sha256 x86_64_linux:   "ab6173ed4e28fc8bb8313fb7062c4551d36fc9513328f3af04cae43b7ebaf47f"
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
