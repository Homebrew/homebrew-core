class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.4.0.0.tgz"
  sha256 "2caee332b8d48e2fddad0f8a0a1811b6cf4c5afab73ae8a17b85ec759cce27ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1fe255bad84264c62b99d114877389b8c25e8ec6f9726e5b501db10a1b9f4b1" => :high_sierra
    sha256 "f4ec8ddda3e8c533cf8402184d22dd3451ad9130284552b6f746a4bbb1249fd0" => :sierra
    sha256 "4c27808b3b8755a856bdc49e9a97569a6bfb3ebc90991f8d3112b4debfd28bdf" => :el_capitan
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
