class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.2.tgz"
  sha256 "e900b8545ffcb69c6d49354b18c43a9f9b8f789d3ae822f34b408eaee8d3e70b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "927a15abf98d767576584c0656688196e643ca9a15969b0e54e58bccc42f37f6" => :high_sierra
    sha256 "4322101b14bb7c235ddd6fb2f102a8f182acb0106ece63bc53d64f3a77224998" => :sierra
    sha256 "4322101b14bb7c235ddd6fb2f102a8f182acb0106ece63bc53d64f3a77224998" => :el_capitan
    sha256 "c34fd149bd7c3a419087f963ecea469b953b5eebd8099457fbf5ed2bb0876357" => :yosemite
  end

  depends_on :xcode => :build

  # Fix pointer comparison error with Xcode 9
  # Reported by email to chuck-dev@lists.cs.princeton.edu on 2017-09-04
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b052485f5d/chuck/xcode9.patch"
      sha256 "fa2e008c8d90321c8876a49f83d7566dead362740711442f8e983d07e98a220b"
    end
  end

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
