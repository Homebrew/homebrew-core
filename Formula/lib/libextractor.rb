class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftpmirror.gnu.org/gnu/libextractor/libextractor-1.17.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libextractor/libextractor-1.17.tar.gz"
  sha256 "215c7d8dc10e0d7644509da2b47a6fa1ba5ebad8ce02904864e54abfb4c3059a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "8e37cce26feb72bd3d002ac037efaa84cb49d30c2b8a61c12133390d35b3a8fb"
    sha256 arm64_sequoia: "70bc6cd43bf90b2f1f9b150ba5acfa1d869574ba8683fa1916c6f30c88ea1ccc"
    sha256 arm64_sonoma:  "618bafd0cca67c1313dbeb7e3b2a83fbfb6673c1cf11d6158fcb27b422a50bfa"
    sha256 sonoma:        "8832af43632806c0afb6d4224f2e0c619ddd0d48c4189041e83821cc33a43978"
    sha256 arm64_linux:   "53c482cea112f4b935d430817819a9a555f47948b3ddc2e2b2c7771ce2709235"
    sha256 x86_64_linux:  "85e0f76179f6e90c3a08cf06857a940b5997d9791d7fb3e0b36b0717167fb72b"
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

    # 1.17 uses glibc-only `secure_getenv` guarded by `#if _GNU_SOURCE`, which
    # autoconf also defines on macOS; use `getenv` there instead.
    inreplace "src/main/extractor_plugpath.c",
              "#if _GNU_SOURCE", "#if _GNU_SOURCE && !defined(__APPLE__)"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "Keywords for file", shell_output("#{bin}/extract #{fixture}")
  end
end
