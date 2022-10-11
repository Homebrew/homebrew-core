class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/13.0.1/bacula-13.0.1.tar.gz"
  sha256 "d63848d695ac15c1ccfc117892753314bcb9232a852c40e32cca88c0e918978a"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256                               arm64_monterey: "42489dd6be579995365266af6ac1e9e0efb0f059114ca11aea2e403d7f07c6bc"
    sha256                               arm64_big_sur:  "10036f12b6348491a9b6721c8df2a1ea79158e6e8c50710aeece83b513c9bbaa"
    sha256                               monterey:       "bad36d8e6a56caf6ec72230e48d71fcf513a09c7dc019a24f1fa3970f6509d1b"
    sha256                               big_sur:        "4026b2d20490a6be9d3648e74b074f615c54af6257d9dbb8b2a6608e5bda8e26"
    sha256                               catalina:       "aee4a24eac06896ca037c18918c264e73e71c5e5ab10cb64758a4baf85ee411d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48579a00a95f1864cb86adf6b9e43bb59faee5b76e7f78d20c9e20159d0e627f"
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

  plist_options startup: true
  service do
    run [opt_bin/"bacula-fd", "-f"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bacula-fd -? 2>&1", 1)
  end
end
