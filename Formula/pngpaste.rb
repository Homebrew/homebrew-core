class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.1.tar.gz"
  sha256 "0fee49ae467b4db58da687089e1729a911f2c0d5c1583a4a0dcb59aba95da519"

  bottle do
    cellar :any_skip_relocation
    sha256 "263e84687d3da619b7349b1295638675719531822dece2b5e1e55a82930900dd" => :sierra
    sha256 "bfb5fd80a48aa24949ef9551f12144afeef8cbc54a04db47476754681dbcac2d" => :el_capitan
    sha256 "e134f7bca93ef8e51d1729c145b060f688999f6d3eeda051f836831c6774c2ef" => :yosemite
    sha256 "eeea5b97cd20b83f7d01fa73d9b8bc98f776dc122769cc682312981dde54b07e" => :mavericks
    sha256 "c8577460546d1c8f7f4cf9e833a420989b1fb94969dc1fcffd1c8f6d07a78e93" => :mountain_lion
  end

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert File.exist? "test.png"
  end
end
