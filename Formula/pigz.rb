class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.6.tar.gz"
  sha256 "2eed7b0d7449d1d70903f2a62cd6005d262eb3a8c9e98687bc8cbb5809db2a7d"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?pigz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32071d100a093f1541cb77fdbe856d2b27f686285262e32c24a5d4d8c6ce4507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "487e4803119cf79952f0604f7c22f400299412210e771d1a5312f75b19903751"
    sha256 cellar: :any_skip_relocation, monterey:       "2276df8aa169d851c1e063447b977036b227104df789a0221e7a28cbb11746dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ed76215af752e06d11b176c3c169a55f76cf2010c01e67e62f7543081137b5e"
    sha256 cellar: :any_skip_relocation, catalina:       "c1e5284c99ef13e0401035597901b5b63d19bbb642fd7206d648193c89d0e6e7"
    sha256 cellar: :any_skip_relocation, mojave:         "0d382426d9bf386f21f8412317b58d05fcaf6ada17b260a1b6e95e8f2e955cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64575f4f87a063b1457a787e4731fde45f31952bde49e0a0123fa29fce2d29d2"
  end

  uses_from_macos "zlib"

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _deflatePending
    # Reported 8 Dec 2016 to madler at alumni.caltech.edu
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "pigz.c", "ZLIB_VERNUM >= 0x1260", "ZLIB_VERNUM >= 0x9999"
    end

    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    man1.install_symlink "pigz.1" => "unpigz.1"
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"pigz", testpath/"example"
    assert (testpath/"example.gz").file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1024k", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
