class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.github.io/lz4/"
  url "https://github.com/lz4/lz4/archive/v1.9.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/lz4-1.9.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/lz4-1.9.4.tar.gz"
  sha256 "0b0e3aa07c8c063ddf40b082bdf7e37a1562bda40a0ff5272957f3e987e0e54b"
  license "BSD-2-Clause"
  head "https://github.com/lz4/lz4.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd29e40287b0a2d665a647acbea5512e8db4c371687147aab5c60bf9059b2cca"
    sha256 cellar: :any,                 arm64_monterey: "284fa580570efdc8056e4fc95dc05f7b0546aa0c346795dd616d4cec8eb99426"
    sha256 cellar: :any,                 arm64_big_sur:  "8cf59a354786ad0ed95a7b531d7149ae03612081818dcdf2d9ca8cb4fe28c07a"
    sha256 cellar: :any,                 ventura:        "6a911ee2a3ea072f414d2983d532b28c34b63a68ff388a0008e1528dc0668838"
    sha256 cellar: :any,                 monterey:       "88b369cea90a0a119c24aa96a614fe7d77de58d18cb1803023dc925679eb905f"
    sha256 cellar: :any,                 big_sur:        "aafb93487e108d302d060265898e4eaa82f5c806ff36dec50871db1c33fdc04d"
    sha256 cellar: :any,                 catalina:       "ddb59c42498843638f1f9d80bd0c7b7126910c4fc8ee7c69fa8784dd4bc95c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1757fefc3840e11c4822e4c2a95aa62aca44a4eaccce6f5c414ea51d1e58bf8e"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = "testing compression and decompression"
    input_file = testpath/"in"
    input_file.write input
    output_file = testpath/"out"
    system "sh", "-c", "cat #{input_file} | #{bin}/lz4 | #{bin}/lz4 -d > #{output_file}"
    assert_equal output_file.read, input
  end
end
