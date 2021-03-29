class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v4.2.5/epubcheck-4.2.5.zip"
  sha256 "2f725b7f491bd7e215fe3fb5492d0554207c838c35165cc195963ddcde39c887"
  license "BSD-3-Clause"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
