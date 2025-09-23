class Id3v2 < Formula
  desc "Command-line editor"
  homepage "https://id3v2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/id3v2/id3v2/0.1.12/id3v2-0.1.12.tar.gz"
  sha256 "8105fad3189dbb0e4cb381862b4fa18744233c3bbe6def6f81ff64f5101722bf"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1e856b634b926775432b085357f04acfccdcb7a370ced3123c4362a90d6eaf3e"
    sha256 cellar: :any,                 arm64_sequoia:  "6d78452187f861e1e8ecf3a23a2e873e251ccda22403a855c86dff5aa6e5bb30"
    sha256 cellar: :any,                 arm64_sonoma:   "9bf6ca393764873ff61916821417e4bfbbe1564682ca2004fcbeef1525c211b7"
    sha256 cellar: :any,                 arm64_ventura:  "222ba809b014c313ebe411cff50e684b04ece17c3d2a380ac0b794b03c3aaae2"
    sha256 cellar: :any,                 arm64_monterey: "d987f37e40ed136bf3eb8a46e867dad0a78f48a1b5457085161f90404b1eee20"
    sha256 cellar: :any,                 arm64_big_sur:  "4eb1279baa3350a16d82139446ab610aa897087821c2dd6fce2a12fac692f958"
    sha256 cellar: :any,                 sonoma:         "38486f0dc0335b2aef545f3da7f12019ac89485ef778b40271d90ddfbd1b4077"
    sha256 cellar: :any,                 ventura:        "585863c7e461122fa8ebcf700a1a87d6bc506f2b4ab21c472974f5c52dcc19b8"
    sha256 cellar: :any,                 monterey:       "f2ef072277b52404b538228954a139a02828b20696ffe12b968d1ae64a40d70a"
    sha256 cellar: :any,                 big_sur:        "363e3ccb0976eddc681538d70f43e498eafc6b03b31bcb1f3f4fccb2382790d9"
    sha256 cellar: :any,                 catalina:       "2476bad339650dc2c12e3dd074b3aba7058e9b3b07c9caf05d6f068ea216d9ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ad8dba5a20ec860000a9f5768fd6f14031e910d7581841b972014c132ea802c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4b36bc47648e0f0c1f54755ba7320310a5bd321baa33aab440de475644a7c85"
  end

  depends_on "id3lib"

  uses_from_macos "mandoc" => :build
  uses_from_macos "zlib"

  def install
    # mandoc is only available since Ventura, but nroff is available for older macOS
    inreplace "Makefile", "nroff ", "mandoc " if !OS.mac? || MacOS.version >= :ventura

    # Fix linker flag order on Linux
    inreplace "Makefile", "-lz -lid3", "-lid3 -lz"

    # tarball includes a prebuilt Linux binary, which will get installed
    # by `make install` if `make clean` isn't run first
    system "make", "clean"
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"id3v2", "--version"
  end
end
