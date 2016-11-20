class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.2.tgz"
  sha256 "e900b8545ffcb69c6d49354b18c43a9f9b8f789d3ae822f34b408eaee8d3e70b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4322101b14bb7c235ddd6fb2f102a8f182acb0106ece63bc53d64f3a77224998" => :sierra
    sha256 "4322101b14bb7c235ddd6fb2f102a8f182acb0106ece63bc53d64f3a77224998" => :el_capitan
    sha256 "c34fd149bd7c3a419087f963ecea469b953b5eebd8099457fbf5ed2bb0876357" => :yosemite
  end

  depends_on :xcode => :build

  def install
    # issue caused by the new macOS version, patch submitted upstream
    # to the chuck-dev mailing list
    inreplace "src/makefile.osx", '10\.(6|7|8|9|10|11)(\\.[0-9]+)?', MacOS.version
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match /probe \[success\]/m, shell_output("#{bin}/chuck --probe 2>&1")
  end
end
