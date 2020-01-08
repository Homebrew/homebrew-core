class Gcore < Formula
  desc "Produce a snapshot (core dump) of a running process"
  homepage "https://osxbook.com/book/bonus/chapter8/core/"
  url "https://osxbook.com/book/bonus/chapter8/core/download/gcore-1.3.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/gcore-1.3.tar.gz"
  sha256 "6b58095c80189bb5848a4178f282102024bbd7b985f9543021a3bf1c1a36aa2a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3451656da696ce7bb47816bf409dd38f279a0dde973b5d7bc60eaec62edbee9a" => :catalina
    sha256 "86a6941a86863482eb97fd03e40749b83b74b7a93d7c7592db4dab6acb9c859a" => :mojave
    sha256 "b9e7e188bee51975ccfdb8f711101a7637f316be0e3aa6b8f80259f7b884f488" => :high_sierra
    sha256 "5fbccf36d0bd51cc4261859b7faf2cc15fe89244109b64abf83512ea73f3259f" => :sierra
    sha256 "5c48b53869e00e0456d57bfa5adde594b5c5e46f3b0678434139765f5d8167ba" => :el_capitan
    sha256 "e215d77d74b8c878a7d7449aada4817714b13024d6bfad78b2b700271e6218ec" => :yosemite
  end

  keg_only :provided_by_macos if MacOS.version >= :sierra

  def install
    system "make"
    bin.install "gcore"
  end

  test do
    assert_match "<pid>", shell_output("#{bin}/gcore 2>&1", 22)
  end
end
