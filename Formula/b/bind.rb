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
  compatibility_version 1

  stable do
    url "https://downloads.isc.org/isc/bind9/9.20.31/bind-9.20.31.tar.xz"
    sha256 "9bfecd503ec79209d321053689c794da9f8dba993a24e9cd6bd7aa87cdf4122f"

    depends_on "readline" # TODO: Remove in 9.22
  end

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "7d65d065d5445ee437d57e4954b8b288c1c8a39f2c543abf062574941344d742"
    sha256 arm64_tahoe:       "711a153584643c474ff1c3d8dcaaaefd6a4a04764b8034d4e2f418df83a50ff9"
    sha256 arm64_sequoia:     "5b8c924e8508e5b7ccf7393b7df3ef027e3053aaa38bbbd12a1ad64077e8692e"
    sha256 arm64_linux:       "050fdaa1ad860679ac443a87e2af04cc3c674a53806f01bef1e6e4ec56f18bcf"
    sha256 x86_64_linux:      "6e0ca8afdd73e7f0862c11224b6c0827ce17c0af8696eb00a5be819b67ff8175"
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

  allow_network_access! :test

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

    (buildpath/"named.conf").write <<~EOS
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
    system sbin/"rndc-confgen", "-a", "-c", "#{buildpath}/rndc.key"
    pkgetc.install "named.conf", "rndc.key"

    (var/"log/named").mkpath
    (var/"named").mkpath
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
