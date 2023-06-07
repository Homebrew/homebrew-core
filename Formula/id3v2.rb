class Id3v2 < Formula
  desc "Command-line editor"
  homepage "https://id3v2.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/id3v2/id3v2/0.1.12/id3v2-0.1.12.tar.gz"
  sha256 "8105fad3189dbb0e4cb381862b4fa18744233c3bbe6def6f81ff64f5101722bf"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "222ba809b014c313ebe411cff50e684b04ece17c3d2a380ac0b794b03c3aaae2"
    sha256 cellar: :any,                 arm64_monterey: "d987f37e40ed136bf3eb8a46e867dad0a78f48a1b5457085161f90404b1eee20"
    sha256 cellar: :any,                 arm64_big_sur:  "4eb1279baa3350a16d82139446ab610aa897087821c2dd6fce2a12fac692f958"
    sha256 cellar: :any,                 ventura:        "585863c7e461122fa8ebcf700a1a87d6bc506f2b4ab21c472974f5c52dcc19b8"
    sha256 cellar: :any,                 monterey:       "f2ef072277b52404b538228954a139a02828b20696ffe12b968d1ae64a40d70a"
    sha256 cellar: :any,                 big_sur:        "363e3ccb0976eddc681538d70f43e498eafc6b03b31bcb1f3f4fccb2382790d9"
    sha256 cellar: :any,                 catalina:       "2476bad339650dc2c12e3dd074b3aba7058e9b3b07c9caf05d6f068ea216d9ef"
    sha256 cellar: :any,                 mojave:         "f0e2da49b513dce2ab73589b2aed98ae2cca184dbe082f92502d87e96ba9731d"
    sha256 cellar: :any,                 high_sierra:    "ca2c1296318425931c5eec52c70adf98665edeb19d5b681271c3b6353ddf171a"
    sha256 cellar: :any,                 sierra:         "3b1d75af49217a58f5ecb6f0e9e34564b299903898c76145218a6496de3a7778"
    sha256 cellar: :any,                 el_capitan:     "941e267b5a214013c8085c7918c0d8c1805c906cacf162191b764d2ae1df265f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4b36bc47648e0f0c1f54755ba7320310a5bd321baa33aab440de475644a7c85"
  end

  depends_on "id3lib"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "-lz -lid3", "-lid3 -lz"

    # tarball includes a prebuilt Linux binary, which will get installed
    # by `make install` if `make clean` isn't run first
    system "make", "clean"
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/id3v2", "--version"
  end
end
