class Epubcheck < Formula
  desc "Validate IDPF EPUB files, version 2.0 and later"
  homepage "https://github.com/IDPF/epubcheck"
  url "https://github.com/IDPF/epubcheck/releases/download/v4.1.0/epubcheck-4.1.0.zip"
  sha256 "8be4f038326099ef95fcbd9dc02a36fb01373833f644573cb964a4442ae727ad"

  bottle :unneeded

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
