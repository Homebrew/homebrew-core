class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/15.0.2/bacula-15.0.2.tar.gz"
  sha256 "55515c2a66af9a86b955daea4089378b864d051b2e6e30383bef36e693acea7a"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://sourceforge.net/projects/bacula/rss?path=/bacula"
    regex(%r{url=.*?/bacula(?:(?!/[^/]*beta[^/]*)/[^/]+)*/bacula[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sequoia:  "30b99d348ab468244a22a3b427a61b97318b374886c3134e62610ab320a8911c"
    sha256                               arm64_sonoma:   "dc5d2dec89a360588b9a03b6d02957d5e6d52d4bbd372942ff7c92a2d479f7a6"
    sha256                               arm64_ventura:  "c69f5533858ba83175376a7bc2a8f3646a7bf7da113979cd65380962fa327dd5"
    sha256                               arm64_monterey: "27eda5572a2b67bf8aac9e1282d4582e6121b9cbe3cf9d7ca198f1f9ea66020d"
    sha256                               sonoma:         "ef78e6f0a2e9da0faf7aa175cce2ab48a46f895b87465d471088482157231047"
    sha256                               ventura:        "f6b4d9fa73464865a7fe466465734ac25350542f96d04c82857d202c82500089"
    sha256                               monterey:       "09e9b0c1974b7a98fdefd0e56bb1ca2201a606e9b4a0263d49e9b923a8aa0702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4fca3bb3f6540789c3a55bd213431c8f768f9d0e0522c3f13ead2541fee6df2"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "zlib"

  conflicts_with "bareos-client", because: "both install a `bconsole` executable"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # CoreFoundation is also used alongside IOKit
    inreplace "configure", '"-framework IOKit"',
                           '"-framework IOKit -framework CoreFoundation"'

    # * sets --disable-conio in order to force the use of readline
    #   (conio support not tested)
    # * working directory in /var/lib/bacula, reasonable place that
    #   matches Debian's location.
    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--with-working-dir=#{var}/lib/bacula",
                          "--with-pid-dir=#{var}/run",
                          "--with-logdir=#{var}/log/bacula",
                          "--enable-client-only",
                          "--disable-conio",
                          "--with-readline=#{Formula["readline"].opt_prefix}"

    system "make"
    system "make", "install"

    # Avoid references to the Homebrew shims directory
    inreplace prefix/"etc/bacula_config", "#{Superenv.shims_path}/", ""

    (var/"lib/bacula").mkpath
  end

  def post_install
    (var/"run").mkpath
  end

  service do
    run [opt_bin/"bacula-fd", "-f"]
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bacula-fd -? 2>&1", 1)
  end
end
