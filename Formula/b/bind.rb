class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"
  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.
  license "MPL-2.0"
  revision 1
  version_scheme 1

  stable do
    url "https://downloads.isc.org/isc/bind9/9.20.29/bind-9.20.29.tar.xz"
    sha256 "587029508b3b1b43229fae416c97e5543aba45809cefaca98a5004a02a5736c1"

    depends_on "readline" # TODO: Remove in 9.22
  end

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "77dbd978bd0a3570e3e78cfccabd2778017d09fde41e54b4eee320d70091f74b"
    sha256 arm64_tahoe:       "057103d28ec6ef77610210fa2f4b1def818d19de15fc399325ee09fe23d7d74b"
    sha256 arm64_sequoia:     "8cb1b551e29400c75a85c88f92836855d5f370221e873d4d16e3eee80fcd0790"
    sha256 arm64_linux:       "ea3eb234ad21347ff28abf728c2ae44f7f53fed732c522c925875361bdae015f"
    sha256 x86_64_linux:      "c85d39263564d9d0c7e377f65c3d037cb40f96531f49b6eb1130ff2544b5b406"
  end

  head do
    url "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

    depends_on "meson" => :build
    depends_on "ninja" => :build
    depends_on "lmdb"

    uses_from_macos "libedit"
  end

  depends_on "pkgconf" => :build

  depends_on "jemalloc"
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@4"
  depends_on "userspace-rcu"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "libcap"
    depends_on "zlib-ng-compat"
  end

  def install
    # Apply macOS 15+ libxml2 deprecation to all macOS versions.
    # This allows our macOS 14-built Intel bottle to work on macOS 15+
    # and also cover the case where a user on macOS 14- updates to macOS 15+.
    ENV.append_to_cflags "-DLIBXML_HAS_DEPRECATED_MEMORY_ALLOCATION_FUNCTIONS" if OS.mac?

    if build.head?
      args = %W[
        -Dlocalstatedir=#{var}
        -Dsysconfdir=#{pkgetc}
      ]

      system "meson", "setup", "build", *args, *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    else
      args = [
        "--sysconfdir=#{pkgetc}",
        "--localstatedir=#{var}",
        "--with-json-c",
        "--with-libidn2=#{formula_opt_prefix("libidn2")}",
        "--with-openssl=#{formula_opt_prefix("openssl@4")}",
        "--without-lmdb",
      ]

      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end

    (buildpath/"named.conf").write named_conf
    system sbin/"rndc-confgen", "-a", "-c", "#{buildpath}/rndc.key"
    pkgetc.install "named.conf", "rndc.key"

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
