class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"
  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.
  url "https://downloads.isc.org/isc/bind9/9.20.19/bind-9.20.19.tar.xz"
  sha256 "42aea9a07497ce99d6b896c4a4859c966dd74da0fefb47426f21a22b111a44b5"
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
    sha256 arm64_tahoe:   "38506ef40849d9bbd420a909bc6fd0f9409f215188127c3f758f53bb1e1649f0"
    sha256 arm64_sequoia: "a5c004378b36fd807e831782b25afe26a00da72cd0b9701cf6e30d7036a90ccd"
    sha256 arm64_sonoma:  "f360cc02c5eeb2fafb3b18d1f1169a5bf868fd6bbd09404887f0c4215af10cab"
    sha256 sonoma:        "f2d38558ca9b4eacc218fc15be7a7a8eeb097d668d88f820b840e6d9cb878fb5"
    sha256 arm64_linux:   "a85b4e2293cb52123fef3b1bf9a369ae73f7c45078a2894c5884d2ffb8ce668a"
    sha256 x86_64_linux:  "0e8bd172d410873a83054c9e79ee30921d38d248270bab30f269f63b1b6ba165"
  end

  depends_on "pkgconf" => :build

  depends_on "jemalloc"
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "readline"
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

    args = [
      "--sysconfdir=#{pkgetc}",
      "--localstatedir=#{var}",
      "--with-json-c",
      "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
      "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
      "--without-lmdb",
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

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
