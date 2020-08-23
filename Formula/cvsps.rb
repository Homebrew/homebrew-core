class Cvsps < Formula
  desc "Create patchset information from CVS"
  homepage "http://www.catb.org/~esr/cvsps/"
  url "http://www.catb.org/~esr/cvsps/cvsps-3.13.tar.gz"
  sha256 "5f078a6e02c394f663893751f128caf643fe00a30b559e87db6f45190c623799"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "98ee59741e5e48ef4ca18f5b0b08cfc8eab19d8e96cebcb75e989334add7411f" => :catalina
    sha256 "8901d9d03137e3ebc2dfa52eeec1b6fb5278aa21fcd2075302ea9c9e20ff1db5" => :mojave
    sha256 "d67b00e52b9688d1249d996eaf94a728691f0b171b1708e83bba07508939d376" => :high_sierra
  end

  # http://www.catb.org/~esr/cvsps/
  # Deprecation warning: this code has been end-of-lifed by its maintainer. Use cvs-fast-export instead.
  deprecate! date: "2013-12-11"

  depends_on "asciidoc"
  depends_on "docbook"

  def install
    # otherwise asciidoc will fail to find docbook
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "all", "cvsps.1"
    system "make", "install", "prefix=#{prefix}"
  end
end
