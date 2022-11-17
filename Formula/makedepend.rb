class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.7.tar.xz"
  sha256 "a729cfd3c0f4e16c0db1da351e7f53335222e058e3434e84f91251fd6d407065"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?makedepend[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7db435d623d3f12d3664338ef9f32c445438260054ec10593d24645d8018105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632a49fb2a96ada364872848c82d4de60ac2847eecefc43b5e9d0a7f16af20e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f3ad09b4aa6533501515ba172cae3bffca8dfb7076c080332b27a1ae997f676"
    sha256 cellar: :any_skip_relocation, ventura:        "8c870cae96f96a20adbfcff8c4dc347148b73c1d27f8cfffe8dd1155cbc50dd2"
    sha256 cellar: :any_skip_relocation, monterey:       "86aa1e7c97901369724cbba722ec3e44e47596a6f99f43925515bddda3cdb55c"
    sha256 cellar: :any_skip_relocation, big_sur:        "40d75eb41d75585be1db186162d1cfad4d2d1e5ba16564ce89d1945395531013"
    sha256 cellar: :any_skip_relocation, catalina:       "1819aa4bd7a1afaf0f19658019b655f1390ee17bd524fe8de8424d7599d85e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dbe095db8dcc3ea6f2de966ca23b3950d01e4b740479b897af2a7d4d8ba8e8f"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros"
  depends_on "xorgproto"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  test do
    touch "Makefile"
    system "#{bin}/makedepend"
  end
end
