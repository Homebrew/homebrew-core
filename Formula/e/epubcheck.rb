class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.1.0/epubcheck-5.1.0.zip"
  sha256 "74a59af8602bf59b1d04266a450d9cdcb5986e36d825adc403cde0d95e88c9e8"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "340ea8a1d792e368fde011bd4d0f74af8e45081acc994eb80dd2cdb04da51bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "340ea8a1d792e368fde011bd4d0f74af8e45081acc994eb80dd2cdb04da51bbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "340ea8a1d792e368fde011bd4d0f74af8e45081acc994eb80dd2cdb04da51bbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "340ea8a1d792e368fde011bd4d0f74af8e45081acc994eb80dd2cdb04da51bbd"
    sha256 cellar: :any_skip_relocation, ventura:        "340ea8a1d792e368fde011bd4d0f74af8e45081acc994eb80dd2cdb04da51bbd"
    sha256 cellar: :any_skip_relocation, monterey:       "340ea8a1d792e368fde011bd4d0f74af8e45081acc994eb80dd2cdb04da51bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c207a874354e0a3e42777ead5f719fdaa28f279bc7b74d240e6a7c5505cf410"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end
