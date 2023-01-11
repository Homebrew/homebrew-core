class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.0.0/epubcheck-5.0.0.zip"
  sha256 "98c5ecce0a6a6bf37034f73465613c4088916b3ef3489f50a7f6897a37a9725a"
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
