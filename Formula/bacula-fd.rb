class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/13.0.1/bacula-13.0.1.tar.gz"
  sha256 "d63848d695ac15c1ccfc117892753314bcb9232a852c40e32cca88c0e918978a"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256                               arm64_monterey: "0ff0297669fece22344c9d26a49137112d941c8fe6d6821c6d26b81114d1f9e9"
    sha256                               arm64_big_sur:  "3572aa477e228c9c27b0c408d5fd0201f81c97983846551232c470903b2159bd"
    sha256                               monterey:       "cb1a1ef69ef2ef0053d2f8ca92279ad0bcd5458cdbe8077bf3acd3c4858dd948"
    sha256                               big_sur:        "3f8d86143bba66c4e2e41ae275353e843ba8d4934473a1fed73f09609eb37519"
    sha256                               catalina:       "c11e6a5e698b06bdfe5e02e825c6bc5ae6e6c8a0a5ff1a8605510ba5b3ad7fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df5b1fa70eca4c5cfb903a7a77ba3d29f1b0097cfc3fdcc4fa0096090ad28421"
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
