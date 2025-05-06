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
    sha256                               arm64_sequoia: "5865d13599bead592dd24ba7ad6b630f1aeb33adadf8a204f63b2778d9f89bee"
    sha256                               arm64_sonoma:  "bbe8baa1d28de02cf1da748963a63c79f7a6a8730af1d43c314809e7f835e649"
    sha256                               arm64_ventura: "952b7913ffd831cc691731c74aa73976197958187d71cf544755bd8536640ffa"
    sha256                               sonoma:        "9e3fe3200227872cc89e6f9606edc904fbc8e416b87349bb40a6b1faa774c56f"
    sha256                               ventura:       "e16028347bfe77bcd7ac5f511440225b545d256bcd8e53b510a90c1ea5306a24"
    sha256                               arm64_linux:   "7b13e3aead69c44d4ee74e7781414a2aaa4b273710837d5a623c4076f25cbb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9427205610275599c958920ccf09b076528aa2ad5e73118260cdae55e15b964"
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
