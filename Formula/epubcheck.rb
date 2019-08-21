class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v4.2.2/epubcheck-4.2.2.zip"
  sha256 "029ee9cda237a42e0d4c1a2b8771a440a4a6326449db843510b16a3c61045463"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
