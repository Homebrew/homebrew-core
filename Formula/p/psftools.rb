class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "https://www.seasip.info/Unix/PSF/"
  # psftools-1.1.10.tar.gz (dated 2017) was a typo of 1.0.10 and has since been deleted.
  # You may still find it on some mirrors but it should not be used.
  url "https://www.seasip.info/Unix/PSF/psftools-1.0.14.tar.gz"
  sha256 "dcf8308fa414b486e6df7c48a2626e8dcb3c8a472c94ff04816ba95c6c51d19e"
  license "GPL-2.0-or-later"
  version_scheme 1

  # The development release on the homepage uses the same filename format as
  # the stable release (e.g., psftools-1.1.1.tar.gz). However, the "Development
  # Release" section comes before the "Stable Release" section, so we can use
  # this heading to anchor stable releases for now.
  livecheck do
    url :homepage
    regex(/Stable Release.+?href=.*?psftools[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "06f275a8b9d1fe1537d8456c91ee2e58b90d514bfc721f2d89a4ef1f56f6f17d"
    sha256 cellar: :any,                 arm64_sequoia:  "12640a4b3994e97fca6c888cdd660d554598bf8bcbb308ceeb9b84215e7d8fb3"
    sha256 cellar: :any,                 arm64_sonoma:   "7b3c2ecfcbac182eeb598a944eb04ae8506330cd0ae1b058a96679f52dad028b"
    sha256 cellar: :any,                 arm64_ventura:  "6d1a0f368538d9943d29048cc34f0db13a9df55d2c100f831dd2a66f987fa32d"
    sha256 cellar: :any,                 arm64_monterey: "1142f7422c522acca28091e7e522e384d00ea96148a74ac67bef674c59f44325"
    sha256 cellar: :any,                 arm64_big_sur:  "474daee5c218ce90013ce498fa84dc5486bfdd1ff736535a87bd618fa72f3da9"
    sha256 cellar: :any,                 sonoma:         "782668ee44ce5af9aecca5d3333653b27970ee7599677ca66a23ad73765e7bdb"
    sha256 cellar: :any,                 ventura:        "99749cecc8e45fe27e56b6d7ab1a8fa17e2486566a065b62f850779d166ae625"
    sha256 cellar: :any,                 monterey:       "cdb289bf8f4b4e86d1145bfbea21cf5ec091c758cfa1f3902fa636a934dbc55b"
    sha256 cellar: :any,                 big_sur:        "42056401c680e3a2372f2b16c78936b6e06c1cb3f8125f1a7c0fff8d23372de9"
    sha256 cellar: :any,                 catalina:       "ac3cc35325cd2b565044a9e864bbf4b3c2e34a39f46b267ae3fc753d63857a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cbf0f067b25985fc24add1230dded4b7d54680dcc2d1f4764afc1d5e762ed28f"
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
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extract to fnt
    resource("pc8x8font").stage do
      system bin/"fon2fnts", "pc8x8.fon"
      assert_path_exists Pathname.pwd/"PC8X8_9.fnt"
    end
  end
end
