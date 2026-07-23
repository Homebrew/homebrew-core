class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://codeberg.org/jbruchon/jdupes"
  url "https://codeberg.org/jbruchon/jdupes/archive/v1.31.1.tar.gz"
  sha256 "9e318ea3440e5dcd33533aaebf85f8307757bb34ea1d12548ceef8d5d75c4bd9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f482ae6d140f2d57ce79f7f4ce86f883b8cdf3689d7723add2973dab2967bf7a"
    sha256 cellar: :any, arm64_sequoia: "7b963f3181f00e7b5d6b489ab65cf9bcfe086383b66b3c8371bab40ab0b7937a"
    sha256 cellar: :any, arm64_sonoma:  "3180b8ef8f149f1da85a9661f5b108ed49fde085cc91475390a9311a4461d8ee"
    sha256 cellar: :any, sonoma:        "666263c8bab14f6cb705ea5c83b6aaea7ccca5fbe3e6726d205a6f95c4b26fbd"
    sha256 cellar: :any, arm64_linux:   "78a4997c423477cd39ab75b312553ddf4b30f2968b7da1bba9ec6da42c04c633"
    sha256 cellar: :any, x86_64_linux:  "39872547225f20c9e98bd23aec2bb7ecbfaa3680c3598f9a33f6bf828ba6259d"
  end

  depends_on "libjodycode"

  def install
    # error: no member named 'st_mtim' in 'struct stat'
    inreplace "filestat.c" do |s|
      s.gsub! "st_mtim.tv_sec", "st_mtime"
      s.gsub! "st_atim.tv_sec", "st_atime"
    end

    system "make", "ENABLE_DEDUPE=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zero-match .").strip.split("\n").sort
    assert_equal ["a", "b"], dupes
  end
end
