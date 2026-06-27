class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"
  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.
  license "MPL-2.0"
  version_scheme 1

  stable do
    url "https://downloads.isc.org/isc/bind9/9.20.24/bind-9.20.24.tar.xz"
    sha256 "989fef1fc88ea59d04cd86f854dca5a4616a20a9968bcdde3c1a3668ab36be08"

    depends_on "readline" # TODO: Remove in 9.22
  end

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b48a55b476fbfac67f94c86ececdf55b1e6ea6a73b6f571d859ea112149087f4"
    sha256 arm64_sequoia: "4526f1717119f539d21887b70c056fb5645e47ce9b2aee1f3b24a9fbf4040fbe"
    sha256 arm64_sonoma:  "218841015053c81bf07814b7ab5c4d9eef4816e84a229be8523ff5524656b1c5"
    sha256 sonoma:        "4e3d15ab173ce5f2bbc4f1626a24aa0f6bac5256a7adc34e59c7bdacece1c0ed"
    sha256 arm64_linux:   "bba9eeead10be52b1b66f03980a8266ea13e374a5357f377c5e0e7ea6d1b59b7"
    sha256 x86_64_linux:  "c3e6a0e216b8b0e64a239fcfd5a9975036b6eb9bdd68b188aa561deaf02e5f35"
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
  depends_on "openssl@3"
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
        "--with-openssl=#{formula_opt_prefix("openssl@3")}",
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
