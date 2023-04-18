class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "https://www.seasip.info/Unix/PSF/"
  # psftools-1.1.10.tar.gz (dated 2017) was a typo of 1.0.10 and has since been deleted.
  # You may still find it on some mirrors but it should not be used.
  url "https://www.seasip.info/Unix/PSF/psftools-1.0.14.tar.gz"
  sha256 "dcf8308fa414b486e6df7c48a2626e8dcb3c8a472c94ff04816ba95c6c51d19e"
  license "GPL-2.0"
  version_scheme 1

  # The development release on the homepage uses the same filename format as
  # the stable release (e.g., psftools-1.1.1.tar.gz). However, the "Development
  # Release" section comes before the "Stable Release" section, so we can use
  # this heading to anchor stable releases for now.
  livecheck do
    url :homepage
    regex(/Stable Release.+?href=.*?psftools[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d1a0f368538d9943d29048cc34f0db13a9df55d2c100f831dd2a66f987fa32d"
    sha256 cellar: :any,                 arm64_monterey: "1142f7422c522acca28091e7e522e384d00ea96148a74ac67bef674c59f44325"
    sha256 cellar: :any,                 arm64_big_sur:  "474daee5c218ce90013ce498fa84dc5486bfdd1ff736535a87bd618fa72f3da9"
    sha256 cellar: :any,                 ventura:        "99749cecc8e45fe27e56b6d7ab1a8fa17e2486566a065b62f850779d166ae625"
    sha256 cellar: :any,                 monterey:       "cdb289bf8f4b4e86d1145bfbea21cf5ec091c758cfa1f3902fa636a934dbc55b"
    sha256 cellar: :any,                 big_sur:        "42056401c680e3a2372f2b16c78936b6e06c1cb3f8125f1a7c0fff8d23372de9"
    sha256 cellar: :any,                 catalina:       "ac3cc35325cd2b565044a9e864bbf4b3c2e34a39f46b267ae3fc753d63857a83"
    sha256 cellar: :any,                 mojave:         "8e53985d7a48b4f927d94ac27339ba7d293181b90fe33d05f22c71ff1e48c126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c750eb92e19169c1bb81129ab8ce270963e9168500b7c59d59d8bb7fc68ee7b4"
  end

  # The `autoconf` dependency originates from 54cfae502ee4
  # which was meant to fix a bug in the `configure` script.
  # We add `automake` and `libtool` to run `autoreconf` to
  # work around the `-flat_namespace` bug. Our usual patches
  # don't work here because the install method called `autoconf`.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  resource "pc8x8font" do
    url "https://www.zone38.net/font/pc8x8.zip"
    sha256 "13a17d57276e9ef5d9617b2d97aa0246cec9b2d4716e31b77d0708d54e5b978f"
  end

  def install
    # Regenerate `configure` to fix `-flat_namespace`.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    resource("pc8x8font").stage do
      system "#{bin}/fon2fnts", "pc8x8.fon"
      assert_predicate Pathname.pwd/"PC8X8_9.fnt", :exist?
    end
  end
end
