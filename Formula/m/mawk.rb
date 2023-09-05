class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20230808.tgz"
  sha256 "88f55a632e2736ff5c5f69944abc151734d89d8298d5005921180f39ab7ba6d0"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5f700ec35697d139a1ed525c1e55cc6f533a370f02da1724ac9b534cc4d1d99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e542b00264b74657560c2cd994a2af6e2912eda04cf5422e184f1013ddc6628"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "516c670e8f56f9fae87172afec424e40af35bdbdedc1d7ae628bac371655b6d4"
    sha256 cellar: :any_skip_relocation, ventura:        "eea76f9612943c3dccc713dda011dd35b81ecbc3e8f35b814b90299e326f6a37"
    sha256 cellar: :any_skip_relocation, monterey:       "5ce969f1120a9dbb428f9b8ee2e65135a394ba051a8fda9198370c12c6b51104"
    sha256 cellar: :any_skip_relocation, big_sur:        "580bf56500f1e5d238edb848a82226832f650b123dd0b0f960b11d04bb8a55f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a38d5ebf693382d356aae99262fe50e353fd04e32138ccd51400f2f5d3006ff"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
