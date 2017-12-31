class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.4.tar.gz"
  sha256 "a4f816222a7b4269bd232680590b579ccc72591f1bb5adafcd7208ca77e14f73"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff33231b4dd499d05a5877892a6aaee2c1d17e93305d636e5fc53f62b26d8e57" => :high_sierra
    sha256 "2ad2349af7453fc09c0cd5980d78c10ca20749cf35f9ffc8ea48a2a0d3db90f0" => :sierra
    sha256 "c494bc1ad2f378cf4f2d1f3d9fba9b78a0258d179cda10d6cc12c5e5e3a51acf" => :el_capitan
    sha256 "dfc83c38b9be8396eeb854fe8b045b9657e693665aad508164b65569fc78f491" => :yosemite
  end

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _deflatePending
    # Reported 8 Dec 2016 to madler at alumni.caltech.edu
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
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
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1m", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
