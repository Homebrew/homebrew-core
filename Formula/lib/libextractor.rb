class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftpmirror.gnu.org/libextractor/libextractor-1.20.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libextractor/libextractor-1.20.tar.gz"
  sha256 "f4fd6c67076e04e907a3032e42bbaa7c0b35aa3a503393c5d74e303ec3eb84b4"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "6b4f3dfd054c316e7f54a1b6d5bee13d96063fc57b795fbc0c6727299e96e60b"
    sha256 arm64_tahoe:       "3117b6f4404da2f184146ca6472b46635983430bd5a37079f806d14c9ef9cad9"
    sha256 arm64_sequoia:     "6824f4de236a442a273e1363dc40bb8a95a2e50d0d7bcb6e729ed89e3d829758"
    sha256 arm64_linux:       "866349c001137b555b147ea84dcfe1ba81f9d57a6a04a777184168dce06d7b77"
    sha256 x86_64_linux:      "26a7ed9531f1de6fa9d481a1d056138ce7f74f4da1e3e4248f00d5136005f8fb"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "csound", because: "both install `extract` binaries"

  deny_network_access!

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
