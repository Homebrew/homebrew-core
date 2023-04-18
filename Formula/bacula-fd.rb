class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/13.0.2/bacula-13.0.2.tar.gz"
  sha256 "6e08bcbe6a4ab070e17e9e9c4e9bc4e944d2e5bd376521ca342c6fe96a20687d"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256                               arm64_ventura:  "82da2a843d76f03bdbc456c10ac52403c4937240718a996193b17d8aeb688a10"
    sha256                               arm64_monterey: "110317c55f1ad9cde6679e52ee6df9f5f0a915dc655c5dbabbbd6d18a0ef4053"
    sha256                               arm64_big_sur:  "b13b510999446703b023699a01130d08f69160e2d26c7dc2a366f06432fc808d"
    sha256                               ventura:        "b7d9faaedab0adc479c600f5e3d462eaaea3ec8111bcbc760a55019f4731b4cf"
    sha256                               monterey:       "36dff1d741e4c9d9676729c808e9e02bc7cea01d2f57b511fa5da53814260984"
    sha256                               big_sur:        "7aa33848a3d4c1d251c35790555bed9a8b6c9d39f3e2fdaea96a896968dfd5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "696f80dacb43185c4bef853807cc61218dcfd2a7624789cb46634113235fd10e"
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
