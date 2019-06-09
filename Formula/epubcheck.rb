class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v4.2.1/epubcheck-4.2.1.zip"
  sha256 "8a2fc55b9b060aae162192b48338e8b2d3423926c483c1da02183d081874cb10"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
