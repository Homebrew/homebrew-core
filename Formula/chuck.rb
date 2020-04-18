class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.4.0.1.tgz"
  sha256 "11a20c34b385e132bf43d5ae6a562c652f631828cc6b1562a4c029bc9a850ed4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d90f8ede5a2afc3ca4b1274da3f73abf25e5c834f64701bf48ddcbc4decf51ca" => :catalina
    sha256 "3dea1fba4982d2770ccfb10c90363a1a1342281900814dc9d617a41b758bc479" => :mojave
    sha256 "8b3feed2d5a3773ee2479a05af8628e83a5fb8e355f3e269202c72fa7ff80258" => :high_sierra
    sha256 "17e8770cd31f86a3cb890bca8c648a2e7321511130016b47b67b08eaceeab2b9" => :sierra
  end

  depends_on :xcode => :build

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
