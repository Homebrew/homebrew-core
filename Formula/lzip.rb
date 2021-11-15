class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.22.tar.gz"
  sha256 "c3342d42e67139c165b8b128d033b5c96893a13ac5f25933190315214e87a948"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/"
    regex(/href=.*?lzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee55e7181bf5a30a39133e75e63a20498f6df1f300d7b211f647656be1e04b9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78014ac2f6011ba98beeabd7aa79e37b6ee78a5e9c72b7bf7594005bfcc7f082"
    sha256 cellar: :any_skip_relocation, monterey:       "b4fe11b4de4a0c31e14057828fd3b75d5f71a9c83af8047b90f98946d1312afe"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd3e7b00a64e6de1f1cbb0446c2a3c0dac5033dd9b2de5f52fe56d7375c0d339"
    sha256 cellar: :any_skip_relocation, catalina:       "91a7214e357c949e0a06736e6a73eb667c0c487efaeebeb4df6fae99ee660575"
    sha256 cellar: :any_skip_relocation, mojave:         "7c4d9d33bda8dd4043a48903d9348e683c1c64c1b0ab39b1680fcaadb952896f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72895e72f99898b116d3b89b7e594a21917d95a08a46f927a9a2532e5269133d"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system "#{bin}/lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
