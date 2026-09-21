class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://www.w3.org/publishing/epubcheck/"
  url "https://github.com/w3c/epubcheck/releases/download/v5.4.0/epubcheck-5.4.0.zip"
  sha256 "33350c61038e71dfb3d45a76aed04bf5481e6d5500cb780f6e98db8bbd15a28c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6740a640702575af8d520803def971d8edc138d9d20d804d7479ec8bd5e420a9"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end

  test do
    assert_match "No errors or warnings detected", shell_output("#{bin}/epubcheck #{test_fixtures("test.epub")}")
  end
end
