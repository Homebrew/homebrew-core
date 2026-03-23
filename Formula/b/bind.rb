class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"
  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.
  url "https://downloads.isc.org/isc/bind9/9.20.20/bind-9.20.20.tar.xz"
  sha256 "19b8335d25305231d5eb8f7d924240d1ac97c4da7c93eaa6273503133aa6106a"
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
    sha256 arm64_tahoe:   "c0af37537615f064c4355b91660e37f27ce5e6cc0bb37141ba21c1692e999a2a"
    sha256 arm64_sequoia: "905de265bf474e5e13cce8f8b79b6ba28e3ff28f2758c4be9509ec04aa52db22"
    sha256 arm64_sonoma:  "8a8b778743c0d5d633c3a2e0c5fd37bbef0c8c63a0bac81616a24ad62e2852c7"
    sha256 sonoma:        "9f7bd40f4492db3251c5cf7eabdd754e288c3ecd8560fe44eba444c6e5c7361f"
    sha256 arm64_linux:   "fd65e76c4b59f0cb82673edc171f2a06a3ca719bf5471f216f4617527bf4a952"
    sha256 x86_64_linux:  "dc1d64d65f8e11633fa7d9001e246bd613c04cf14ae30dc1bc1e6e8c7535fe9f"
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
