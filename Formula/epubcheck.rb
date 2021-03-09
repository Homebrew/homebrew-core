class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v4.2.4/epubcheck-4.2.4.zip"
  sha256 "11550a96f0695cb475026664f0015133e88d8a58f9f8b31180515f8e7ae2b7d2"
  license "BSD-3-Clause"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
