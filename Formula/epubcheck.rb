class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v4.2.6/epubcheck-4.2.6.zip"
  sha256 "3f73c1265cc92e3b53ffda6cd5bbeb58505b2b0c43411c26e74d8df1b193b2c0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94dc30bc00494c090c9b47d285fb2e1b904c5e22c59b721ad11a0e018a1d4291"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
