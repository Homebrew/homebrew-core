class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  url "https://github.com/hercules-team/augeas/releases/download/release-1.14.1/augeas-1.14.1.tar.gz"
  sha256 "368bfdd782e4b9c7163baadd621359c82b162734864b667051ff6bcb57b9edff"
  license "LGPL-2.1-or-later"
  head "https://github.com/hercules-team/augeas.git", branch: "master"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "1eea47a5e1d296258d69a96a3adeac7daf2685582a3bbe441ab939971e17f49d"
    sha256 arm64_ventura:  "645ef0a289b82eba6c529784382de45763432457902402b9c33c5818387edb3a"
    sha256 arm64_monterey: "a1cd27ecd44f8e69c9e54433cbcfdee18d20f3a35f3b94e048f8b520bca045a8"
    sha256 arm64_big_sur:  "677f8c16ca36a6360acba59123d166dfa336f5e8c419263c0732ea50e018e675"
    sha256 sonoma:         "989493c0179d839ec6c3ee3202985d7531f19082279d9a0dc34678a99c8b9b20"
    sha256 ventura:        "8642b0d19d8a11a1d7f46deaa63cb96b9108f1511e82072781bddbccb82aa607"
    sha256 monterey:       "aeb35b8dd081642befbb5f67a373d06e459b70aab03f4954e76ab0d217a230d4"
    sha256 big_sur:        "42c50013aa4e9134aa5306762ea0e022057166b311ddd6dab0e74374a0ff42e0"
    sha256 x86_64_linux:   "bbb9c2c8b61a5000b52927daccca19cc9eb3a3d22d0a1d911d67da52a0a0968f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    if build.head?
      system "./autogen.sh", *std_configure_args
    else
      # autoreconf is needed to work around
      # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44605.
      system "autoreconf", "--force", "--install"
      system "./configure", *std_configure_args
    end

    system "make", "install"
  end

  def caveats
    <<~EOS
      Lenses have been installed to:
        #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/augtool --version 2>&1")

    (testpath/"etc/hosts").write <<~EOS
      192.168.0.1 brew.sh test
    EOS

    expected_augtool_output = <<~EOS
      /files/etc/hosts/1
      /files/etc/hosts/1/ipaddr = "192.168.0.1"
      /files/etc/hosts/1/canonical = "brew.sh"
      /files/etc/hosts/1/alias = "test"
    EOS
    assert_equal expected_augtool_output,
                 shell_output("#{bin}/augtool --root #{testpath} 'print /files/etc/hosts/1'")

    expected_augprint_output = <<~EOS
      setm /augeas/load/*[incl='/etc/hosts' and label() != 'hosts']/excl '/etc/hosts'
      transform hosts incl /etc/hosts
      load-file /etc/hosts
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/ipaddr '192.168.0.1'
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/canonical 'brew.sh'
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/alias 'test'
    EOS
    assert_equal expected_augprint_output,
                 shell_output("#{bin}/augprint --lens=hosts --target=/etc/hosts #{testpath}/etc/hosts")
  end
end
