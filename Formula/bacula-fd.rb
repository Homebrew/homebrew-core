class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/13.0.3/bacula-13.0.3.tar.gz"
  sha256 "0949c32be1090585e88e4c01d828002e87603136d87c598a29dff42bb3ed2a40"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256                               arm64_ventura:  "093e3cd13f2eeff54913fff81ea84b986e4a110a4dc3119ec3ec881118741962"
    sha256                               arm64_monterey: "4da12b7a80a085cfa3e3482e368d26d6fef56bcf4685628d337bc24eff0b7d04"
    sha256                               arm64_big_sur:  "1599974c658fe5281094ea70ba72b7301f7c126a22030e03979bd663a7d3ae2b"
    sha256                               ventura:        "d7c37368083463ab0fe57c87bb19d077d2accf43a52a7e1cf30653af0550c7b4"
    sha256                               monterey:       "9cbd1a22e2baa7a9097989457b8cf6fe6523bb357381e141a925a093f6b2947c"
    sha256                               big_sur:        "a7a941908b02a880f867a0b95990e4725ac7401a0b64aa171ce749ccb590a6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aea0a0586542c2bee73db64ea57e4c8b2d347375f2d1bc5239001dd8f9dcfee0"
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
