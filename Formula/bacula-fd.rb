class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/11.0.5/bacula-11.0.5.tar.gz"
  sha256 "ef5b3b67810442201b80dc1d47ccef77b5ed378fe1285406f3a73401b6e8111a"

  bottle do
    sha256                               arm64_monterey: "6a3d9d37ab790ea4ad9d785de89bbb98b3379664f105591d2766a72e43bbd688"
    sha256                               arm64_big_sur:  "90c424f536aadb83c4532a7b32c2e1e63d3fb1bafc561b9746cfbc27cda3a39e"
    sha256                               monterey:       "77e649a941a05b044cbba85fbd63fdf5eead80c70bc03638a1fc5b5e6fcd93d3"
    sha256                               big_sur:        "0912e3a6669920a1935bb6d2fc9eebd610277ce3b2917db4558ca18fb14109bd"
    sha256                               catalina:       "9d66cc373192f4c50a9a4c22a0cd162c7ce57604d7e89c95197a13e64a7b2973"
    sha256                               mojave:         "6e21aa8aa033bf0393ce813ebd77890f3ad1b9e68ca58990d6177b219ddd6d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49bdfa04ce4520b84cd06dcc07a45720712866d2a76c0a93bf0905712f45edf4"
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
