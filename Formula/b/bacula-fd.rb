class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/13.0.4/bacula-13.0.4.tar.gz"
  sha256 "14e4c62d381a1008422e3fd14aad19b2614103d89078926d7337f850e3b473dc"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://sourceforge.net/projects/bacula/rss?path=/bacula"
    regex(%r{url=.*?/bacula(?:(?!/[^/]*beta[^/]*)/[^/]+)*/bacula[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "1ec48a5f302a21c3fc4bd9300e3c09926a1b3920f5b19ab400b111b950094322"
    sha256                               arm64_ventura:  "f5e56218a1973c99a843b25046d330ee6bed19fc88e659d65458f5507097f5fb"
    sha256                               arm64_monterey: "f78f3557ff23e54097cceea8f4f879f5d91a35549bdfee082416c7ce5e420fe5"
    sha256                               sonoma:         "bbe5ebb33014bd1e2c01b8c9d2be28c7231347d8a9c0e7278feeccbfc20a83f9"
    sha256                               ventura:        "e3aec2b7bee4976897b23992d606f0aae5300de3b06cd1bc62c71e3a85c501a3"
    sha256                               monterey:       "0b6f899dec38475e95f1c069a122d5c7ee49b1842053655dcc73021c74468ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c2dc1bd5170d9493b483becb86e2c75be5a45f9190eea88657f45ce7dc846e0"
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
