class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.4.tar.gz"
  sha256 "a4f816222a7b4269bd232680590b579ccc72591f1bb5adafcd7208ca77e14f73"

  bottle do
    cellar :any_skip_relocation
    sha256 "341c5f3c0a82aedd822b2dd187ecc12b3dbdea9b2f00b08ce7ba049916557314" => :mojave
    sha256 "216e716eafd2786ed6fa672daf27bb77b420e05f92a14cfeccab28a6be6b7778" => :high_sierra
    sha256 "9173b4bdf36c787ad7a3b7d738236e0393430b607ba44d5a32fa387b008a347a" => :sierra
    sha256 "d0c4ec5ac96ab0262d5e67bd5df5432d7dc40ac1404341962c02835ca8451b5c" => :el_capitan
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
