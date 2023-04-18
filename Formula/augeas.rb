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
    sha256 arm64_ventura:  "e7af25f8e908023500bcb581958c7c0f101c7637b13fc918f447112a6771a38a"
    sha256 arm64_monterey: "05d7ba80b5c4f82922df2e74482a051fc9d2e126f349df9e20661f913c01bb77"
    sha256 arm64_big_sur:  "1a96e1000a18fc19725e291137fbf4e303c7708b15eabffd10c23ee4171769f9"
    sha256 ventura:        "5b2c22d8b533afae5ac6e61fad11b911625524e6d20718d2befd5b3d8a894a3e"
    sha256 monterey:       "57ded909692f70769ab2f1940e3e93fc4273422f49c0b17b8ab832b9eabb124e"
    sha256 big_sur:        "7f2e5d001c23b8629b24040e20d9bd7c0542c77646fe23852d730d8e442409bb"
    sha256 x86_64_linux:   "d1c0c9c1add2c53fded9e5ad269f6afa20e2a88aa3f711bbd4d156568b1b559f"
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
