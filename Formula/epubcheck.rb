class Epubcheck < Formula
  desc "Validate IDPF EPUB files, version 2.0 and later"
  homepage "https://github.com/IDPF/epubcheck"
  url "https://github.com/IDPF/epubcheck/releases/download/v4.0.2/epubcheck-4.0.2.zip"
  sha256 "f3752b5c9140e1aa359d8fea96e46d40e3500544f101628802151ed71f744df8"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
