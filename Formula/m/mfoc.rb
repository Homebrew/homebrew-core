class Mfoc < Formula
  desc "Implementation of 'offline nested' attack by Nethemba"
  homepage "https://github.com/nfc-tools/mfoc"
  url "https://github.com/nfc-tools/mfoc/archive/refs/tags/mfoc-0.10.7.tar.gz"
  sha256 "2dfd8ffa4a8b357807680d190a91c8cf3db54b4211a781edc1108af401dbaad7"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/nfc-tools/mfoc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3bc4430e432a6be762cc41bde75929ad6fe8395ce5b851fee12e161c81c6bf21"
    sha256 cellar: :any,                 arm64_sequoia:  "3b89cfda6f79a47fad9df8891458eaf4923c2c6fdea0e17a75bd5f9c1fe7fdc3"
    sha256 cellar: :any,                 arm64_sonoma:   "1d07e71a99eb298fee125dca589933a08e3c4559932a30f4fa7cd162b4852ff9"
    sha256 cellar: :any,                 arm64_ventura:  "d49bb67cdb4749b3c1d5d8150ddfb77d1a48b4a5eafefb0a25f3c26ef1dbc9c2"
    sha256 cellar: :any,                 arm64_monterey: "f11d48dde5f68cb4bfdb4e41dd3fff7e123fa10a9ca7efae8b63ab802a7a85e1"
    sha256 cellar: :any,                 arm64_big_sur:  "91a8acedb7304016340cda6367f447e0f64d2c1e0f36ce25b414fc13fd09c5b0"
    sha256 cellar: :any,                 sonoma:         "7eca0568d9e83844424b0d3fb5bbdeac88c09b69054ee245a014274be4d825ab"
    sha256 cellar: :any,                 ventura:        "fe4940b2a72f324ba2c68b9d9cd454b1aeedaae44634a24fbaf6b64fab2a737d"
    sha256 cellar: :any,                 monterey:       "105fa3c4775e833eeae572bf9390702e56111eace14cae4f9391fc9f91d6b263"
    sha256 cellar: :any,                 big_sur:        "8c753373dea6cbd38da65e10340974fbeb654d1ced7c68a75d4a414360b73a39"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b488915855d2b7999488a17cfa7c4a8025043b225d606baff0662e33a0b0124f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3582c2f917cc657ba2c249b26fb0b064f5f93dcbee7e5fd310dec652c123450"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "No NFC device found", shell_output("#{bin}/mfoc -O /dev/null", 1)
  end
end
