class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.net/"
  url "https://github.com/autotrace/autotrace/archive/refs/tags/0.31.13.tar.gz"
  sha256 "56ab571d9c1213582fe73614c045f60b80024a06c88e7940d94aaeac77382a4c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/autotrace/autotrace.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "5c9d62b9ebc44a0b68341e865f2719cefcbb0945f656b3be32d7a011b529add9"
    sha256 cellar: :any, arm64_golden_gate: "3f0778e7c5a803b71521b593db8e9ee4fbfc4ced8249cdcccb4b5f5c280c9cd6"
    sha256 cellar: :any, arm64_tahoe:       "85ab58537aee3d2ca5d6f6165f6c8ccc7ac0a807931ce1e48f06b5dcf04cd1c1"
    sha256 cellar: :any, arm64_sequoia:     "1ac6b37d85f89fe58f8ce49eec5fc973a02583f49325cf9f6dcb2a45dffdfb59"
    sha256               arm64_linux:       "54a79aeca4f6b7116d9cd2203b7cf4856fde62f13bc13838ea6d35b647783a5a"
    sha256               x86_64_linux:      "309530080f40c943f9e9df9ae99edab9bf8d417840cd20ff9f329c8c5704a5cd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pstoedit"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  deny_network_access!

  def install
    system "./autogen.sh"
    system "./configure", "--enable-magick-readers",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system "convert", "-size", "1x1", "canvas:black", "test.png"
    system "convert", "test.png", "test.bmp"
    output = shell_output("#{bin}/autotrace -output-format svg test.bmp")
    assert_match "<svg", output
  end
end
