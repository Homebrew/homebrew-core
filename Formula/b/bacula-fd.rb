class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/15.0.3/bacula-15.0.3.tar.gz"
  sha256 "294afd3d2eb9d5b71c3d0e88fdf19eb513bfdb843b28d35c0552e4ae062827a1"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://sourceforge.net/projects/bacula/rss?path=/bacula"
    regex(%r{url=.*?/bacula(?:(?!/[^/]*beta[^/]*)/[^/]+)*/bacula[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "06814f801d435234eda5bc445d9faa6634fb646fea8fc9b9c801daad7daf564c"
    sha256                               arm64_sequoia: "63a1ce591508863f9c78b987c14dd6bf168d49349b8479310685cbb442cd122d"
    sha256                               arm64_sonoma:  "b41791686a3499085b3522f3c4a0fa7ac85cd7a404e9c9cafda74ce0dfba6c43"
    sha256                               arm64_ventura: "41e90a2019cdb02163dd8ff8044117f16960eda69ccd8fa8811c9ab3e6a9bfd7"
    sha256                               sonoma:        "ab5d9db5f59ce74e1c8a1a33413e4aa8e26a7ff5237e2bc86038b1f41fb08ada"
    sha256                               ventura:       "42c3f2e6d299ef9e9bf8f28d8b1111e446bfbed29f538a50237d340f509acf29"
    sha256                               arm64_linux:   "c85f6c053e80dae666859a88d5250366c368a235af84a7414b7d3e08981043d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf5f15762df9a4ef212ff679a0973851ae21ab9faa251e2944e4e687b4b73e1"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "zlib"

  conflicts_with "bareos-client", because: "both install a `bconsole` executable"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
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
