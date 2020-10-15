class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.4.0.1.tgz"
  sha256 "11a20c34b385e132bf43d5ae6a562c652f631828cc6b1562a4c029bc9a850ed4"
  license "GPL-2.0"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "95574b4ee2d10154b683e9b506e3ea83f7038e5b8a8a5b8eacfabd80006ffba0" => :catalina
    sha256 "d55689ced88b9cf3a280b39b6a0a92ab33f7b834f6d6c704b5ac57fe755f0dc3" => :mojave
    sha256 "bf6caf2f7ecd22b43afca372f0fd7e26fab5145aee922725ddbb237039cd1883" => :high_sierra
  end

  depends_on xcode: :build

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
