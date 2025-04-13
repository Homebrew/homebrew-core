class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://tracker.debian.org/pkg/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.22.tar.xz"
  sha256 "043569241cdd893cc45e00f917c94c123d0c24143895d91c4d08c6c567e35155"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b424a595625fd72f16ca4a64a6b3c76628eb368b4caf3d46f3fd3ed679a0b85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb55c1b5ff723041ecb4b4547217f64b9333a0a588a7578238a33fbff45c193"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f44d04b0b597f2da95967a4b2be1e106f111357a558b5661ef3bf8b89abca6f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5de2cda2b72681b31d1bead67e307bae581f67f9045389edeb2e0cf064ac6895"
    sha256 cellar: :any_skip_relocation, ventura:       "dfdbd0132eff2547406593c94239b74011d3a9c614123435e62fe437a382f0d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d13d8bded021ec8694b6d1921d142c1b26745e9d3dda9a512441d01db8833199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df8cd2bb8e760398a01c3fc5e25eef69a37193ab063fd32d95a7f99f989f2b32"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build # for libintl
  depends_on "libtool" => :build
  depends_on "po4a" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_path_exists Pathname.new(output)
  end
end
