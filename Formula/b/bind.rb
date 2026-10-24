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
    url "https://downloads.isc.org/isc/bind9/9.20.30/bind-9.20.30.tar.xz"
    sha256 "9e1443a40a72a30272cbc3196d020a6b2e26937111c83e59e101e82e1e3b4fef"

    depends_on "readline" # TODO: Remove in 9.22
  end

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a802e8c952a5d3a014671f4a2f60cba55fb66f21ff9266aaf80d767a899b4d5a"
    sha256 arm64_tahoe:       "ff43cef2f7d9e9464a6c9a39a650dc61ba0e8a517d26449e9137372170cb560c"
    sha256 arm64_sequoia:     "de9bc6de90a3e8bbd5f282c9eb739916f7655277802d22be30ba97dd27801fe9"
    sha256 arm64_linux:       "ba6338a0b2a4cd6fec430ff9a350c7f90ce4efa10f49de74caaa8883ac15056f"
    sha256 x86_64_linux:      "7eb78197a96eb11ed249fbf54221eae1a3d26e7725678d21dc37df56c00eeb78"
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
