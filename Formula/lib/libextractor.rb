class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftpmirror.gnu.org/gnu/libextractor/libextractor-1.16.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libextractor/libextractor-1.16.tar.gz"
  sha256 "0d54668538a9f9612934f5c5a3218e39632f2328fb078df29fd7c8afc859376c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "54c8ba537d357d11e60953f7fd61b6c75c709c844e9a53e8d3034a80d591bd22"
    sha256 arm64_sequoia: "d559fc70e37c2e90d3ec4e9b4327b8fbeede7cbaaf3d62d6ffb8ed4727e5e480"
    sha256 arm64_sonoma:  "4fb7812c924cf6ace54a6ea9512616c1d3ffe838870b8421dc9b297170da13c2"
    sha256 sonoma:        "c729f8320d73aab60fff0fbd976dcde1fd6e77bf849e4345f7f2b41faeae510a"
    sha256 arm64_linux:   "195638982682a12cbb8bcc1e864df2b6dce84a2974c47c15ce7e891dccad4ee5"
    sha256 x86_64_linux:  "4b8c453900de940c0e8a5ec553b27fac500d2b2ac8e5080ec1da38d237e7f81a"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "csound", because: "both install `extract` binaries"

  def install
    ENV.deparallelize

    # macOS defines ntohll as a macro, clashing with the local definition
    inreplace "src/plugins/qt_extractor.c",
              "static uint64_t\nntohll (uint64_t n)",
              "#undef ntohll\n\\0"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "Keywords for file", shell_output("#{bin}/extract #{fixture}")
  end
end
