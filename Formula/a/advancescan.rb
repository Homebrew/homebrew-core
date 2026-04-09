class Advancescan < Formula
  desc "Rom manager for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/scan-readme.html"
  url "https://github.com/amadvance/advancescan/releases/download/v1.18/advancescan-1.18.tar.gz"
  sha256 "8c346c6578a1486ca01774f30c3e678058b9b8b02f265119776d523358d24672"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "911a3103d9849fb5bd1ec1b79d63a77efe11af81bdcda9306682ac32c0a5feaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d51fc384b0cc7ea1ad507ed2b4e4c4c8bec82d8661cc331c12ae3ef562371ce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0132020ba31c3f8b7dae6693871fac00f84d36de7d230230884a3b3b093e0ead"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b8f678959fcf8389944302f432587b91a90d94249839d1752bdd89cc14a831f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f3ebcc210b8625a0d0ffce9773d26c6a40bc01568d14d754d97e578f6fc83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cb1c3cee50692f29ab979afff87ab75f36e117a0208070fa69834defb9879da"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"advdiff", "-V"
    system bin/"advscan", "-V"
  end
end
