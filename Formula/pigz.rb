class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.5.tar.gz"
  sha256 "a006645702caaecace633a89eb5c371482b44a48d04f34e0058e2b85d75d4c36"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?pigz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ab03009238f5a5181cd69b03905f9e85e89773ec643691ce3eb010d008d39aa0" => :big_sur
    sha256 "9ca4d00080d69cb2df3f9301a86c9518693a75143d6dac70eee7fbe005a297d6" => :arm64_big_sur
    sha256 "1f054b879a528740c7a6b854ff7fe948d2706dae808088fa19f82102b1ad174b" => :catalina
    sha256 "0338683c663acf7cf0e403cf044ae62512215739bb811c3751165f2368edead3" => :mojave
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
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1m", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
