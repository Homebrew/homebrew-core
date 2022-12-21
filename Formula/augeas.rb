class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/hercules-team/augeas.git", branch: "master"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://github.com/hercules-team/augeas/releases/download/release-1.14.0/augeas-1.14.0.tar.gz"
    sha256 "8c101759ca3d504bd1d805e70e2f615fa686af189dd7cf0529f71d855c087df1"

    # Remove `#include <malloc.h>`, add `#include <libgen.h>`.
    # Remove on next release.
    patch do
      url "https://github.com/hercules-team/augeas/commit/7b26cbb74ed634d886ed842e3d5495361d8fd9b1.patch?full_index=1"
      sha256 "4f5c383bea873dd401b865d4c63c2660647f45c042bcd92d48ae2e8dee78c842"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D*?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "8efcca1e374d9d238c8ec4aad93269c62e64d7f604235a0ae73b068814c78814"
    sha256 arm64_monterey: "9121d1ac0dc18a438172e5263887bda632350c43685a522218ca150d6a445bb3"
    sha256 arm64_big_sur:  "95a3be7acb99bde6f6f9eb50409c33abbcc854b5b8478c818a1ef2701fb5ba3c"
    sha256 ventura:        "df3ad97e0413003227700405470ad81d414800eb1ea742c6ba5d0c26feb5e254"
    sha256 monterey:       "6590ef5711dade266f63cd4d97afe0c54e8b2e854380c498e5dd0a8f37f46379"
    sha256 big_sur:        "aaed7f82bb2fc6b940f4068049945c452eba4017bdd87ea86ca5124800c007d2"
    sha256 x86_64_linux:   "35c90b53f33210c6b1952673ed62f33be5f90cb0a280f96f95e8cb930c4696fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
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
