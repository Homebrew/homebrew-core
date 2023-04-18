class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz"
  sha256 "31da5562f44c5f15d63340a09a4fd62b48c45620cd302f77a6d9acf0077879bd"

  livecheck do
    url :stable
    regex(%r{url=.*?/giflib[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ced5a24b12f7057504aa8821a81c03c4d83ff6ba861487e25eba34b863237c20"
    sha256 cellar: :any,                 arm64_monterey: "6a1194d7b2d991583e3b5d46782ac8d0cecfc35bc28a5b4daf86ec4311cc7cdc"
    sha256 cellar: :any,                 arm64_big_sur:  "e9a78b55a43f68f2552f845fff27d1c247ed865b1dd653f4c8ab259594411f86"
    sha256 cellar: :any,                 ventura:        "7b542ce4281136276979dfbe45cea1a84060f624ee307917c24499398b210103"
    sha256 cellar: :any,                 monterey:       "fa6adb4afc1abd76f8a80afd8c25572f7c990cbfc88a43496350e8c363048217"
    sha256 cellar: :any,                 big_sur:        "dc23500f50d599c4dbfcea0107b643bef41538c2f5fd162b049f82d21e3d32d5"
    sha256 cellar: :any,                 catalina:       "ad97d175fa77f7afb4a1c215538d8ae9eff30435de7feaa6a5d2e29fca7fef4d"
    sha256 cellar: :any,                 mojave:         "42d2f8a6e9dbf9d4c22a2e64581c7170cc7dcb2a0e66df383efc67b7bc96238d"
    sha256 cellar: :any,                 high_sierra:    "e1a30a20ad93cd9ec003027d7fba43a7e04ced0bff4156614818cccfc9dec6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d753208ed3a4bbd60b59e3ca4466196e4b935d4f434935b540fc6bfb5f3e0385"
  end

  # Upstream has stripped out the previous autotools-based build system and their
  # Makefile doesn't work on macOS. See https://sourceforge.net/p/giflib/bugs/133/
  patch :p0 do
    url "https://sourceforge.net/p/giflib/bugs/_discuss/thread/4e811ad29b/c323/attachment/Makefile.patch"
    sha256 "a94e7bdd8840a31cecacc301684dfdbf7b98773ad824aeaab611fabfdc513036"
  end

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end
