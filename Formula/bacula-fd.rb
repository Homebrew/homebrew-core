class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/11.0.6/bacula-11.0.6.tar.gz"
  sha256 "0195a08bcd4f578ae4a9ce0d91f7f86731c634d56b810534722d721b2a9eecb7"

  bottle do
    sha256                               arm64_monterey: "9e4bd50607f95bd6d674e8c735dba12e2ad0764496845c89823461d8116b5c65"
    sha256                               arm64_big_sur:  "f063999629535e0fd70ebd57b58f6b79e4119741b734d072ce509b1943d2bbe1"
    sha256                               monterey:       "46b2043db486c8e8821b342e7892305634f3be0c320cd78e0240fd98cd4c5060"
    sha256                               big_sur:        "513208f4394d97cf93cb235f7cf53528ff326f687ae749cb83836b7a8844a888"
    sha256                               catalina:       "2c24e7d729ebea46a6a706b20add5274914ef21d43051613c391eec791768ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85685ff002be62bdc15d1a10975086a8abc4b587abe199d0078c605d71501a58"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

  conflicts_with "bareos-client",
    because: "both install a `bconsole` executable"

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

  plist_options startup: true
  service do
    run [opt_bin/"bacula-fd", "-f"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bacula-fd -? 2>&1", 1)
  end
end
