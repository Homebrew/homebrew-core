class Cvsps < Formula
  desc "Create patchset information from CVS"
  homepage "http://www.catb.org/~esr/cvsps/"
  url "http://www.catb.org/~esr/cvsps/cvsps-3.13.tar.gz"
  sha256 "5f078a6e02c394f663893751f128caf643fe00a30b559e87db6f45190c623799"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7e61acca8f1ee7d1489615e38299d49fafad781a0efabc45a60a35482deef9a" => :big_sur
    sha256 "6ae50a7bef6cc5545507ef050848d0a9d487dc9b91ff324695c78bdfeb1eee36" => :arm64_big_sur
    sha256 "98ee59741e5e48ef4ca18f5b0b08cfc8eab19d8e96cebcb75e989334add7411f" => :catalina
    sha256 "8901d9d03137e3ebc2dfa52eeec1b6fb5278aa21fcd2075302ea9c9e20ff1db5" => :mojave
    sha256 "d67b00e52b9688d1249d996eaf94a728691f0b171b1708e83bba07508939d376" => :high_sierra
  end

  # http://www.catb.org/~esr/cvsps/
  # Deprecation warning: this code has been end-of-lifed by its maintainer. Use cvs-fast-export instead.
  deprecate! date: "2013-12-11", because: :deprecated_upstream

  depends_on "asciidoc"
  depends_on "docbook"

  def install
    # otherwise asciidoc will fail to find docbook
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "all", "cvsps.1"
    system "make", "install", "prefix=#{prefix}"
  end
end
