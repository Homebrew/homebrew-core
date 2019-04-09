class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v4.1.1/epubcheck-4.1.1.zip"
  sha256 "0d07de09644d40a373bd7b6a35ab08bbf5537095c4f58a667ab98421e703b16a"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
