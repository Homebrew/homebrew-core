class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.0.1/epubcheck-5.0.1.zip"
  sha256 "783da9f26d5ed56fa240efe73482dc338189e14ac1e6e6bb72699e5e7f22641a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6115d50769b1fcefd4ea30fcd097eefdc426da30165a3c377c5210d0555bc802"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
