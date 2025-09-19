class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://tracker.debian.org/pkg/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.23.2.tar.xz"
  sha256 "79e524b7526dba2ec5c409d0ee52ebec135815cf5b2907375d444122e0594b69"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "329887b6a8522b5f303b0787af83a7b26ae386d7feb87c069c4ce2387a9ab785"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697c3bde9f2847949cd3b06bcb526b7afc8526828d5c9498b6826a77f5e69f3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05a1e2686176a116605d4ab6e5264340ca9dd83aca4533ada3f2cd56dc7a5dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "467ec22e22e45c4bf5ac0ec66521805fd548a2067fd35255e3cfc29a773aca36"
    sha256 cellar: :any_skip_relocation, sonoma:        "08d55d96cb4eae2950159943ba4f0e010adfeb01c8541a2d14edce96a4bcb945"
    sha256 cellar: :any_skip_relocation, ventura:       "cf09f6c0bd7042a1c473c9970ab98f28abc2fb3e7fb77cf51f7180ad05b07299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f255a4df75b8734c998aa1ba8215d945bc542ad7c119854f48cefbaa6ab8909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3425081c6784a3a440bad62d02f8d0111decbf747bcf7df94676bd4b74e36e76"
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
