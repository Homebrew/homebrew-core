class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftpmirror.gnu.org/gnu/libextractor/libextractor-1.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libextractor/libextractor-1.13.tar.gz"
  sha256 "bb8f312c51d202572243f113c6b62d8210301ab30cbaee604f9837d878cdf755"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c2fd159149aca1a534cbfefa4d19fc9247eeb7c1884ec184d02b51abc1a10104"
    sha256 arm64_sequoia: "ff68520aee98762315e38bac3cd80d4671aea25cdfea91b74a94ca097ccff5d8"
    sha256 arm64_sonoma:  "26b036e111b2bb5ce208cb586fb4c5790d24ffdf4a87587bb6bb46ca0c484e96"
    sha256 sonoma:        "d45f64b417e7c7029835b32d45ad8222b64b24ade727cfc0b795869438f35c9a"
    sha256 arm64_linux:   "46b5c12a0f96cb68769bb7bc30fb1d4b64cab9051e9cc3e902f342f2f6cfc92d"
    sha256 x86_64_linux:  "62f5457e278cd0c44c770067398736631f9e516738e2a2c672e65d6eb27de541"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "csound", because: "both install `extract` binaries"

  def install
    ENV.deparallelize

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "Keywords for file", shell_output("#{bin}/extract #{fixture}")
  end
end
