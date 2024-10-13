class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.1.0/epubcheck-5.1.0.zip"
  sha256 "74a59af8602bf59b1d04266a450d9cdcb5986e36d825adc403cde0d95e88c9e8"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0f49db31f1124e428d4a0e574e130ba7abd35a5467426642b6d84eacb19c672b"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
