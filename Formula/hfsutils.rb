class Hfsutils < Formula
  desc "Tools for reading and writing Macintosh volumes"
  homepage "https://www.mars.org/home/rob/proj/hfs/"
  url "ftp://ftp.mars.org/pub/hfs/hfsutils-3.2.6.tar.gz"
  mirror "https://fossies.org/linux/misc/old/hfsutils-3.2.6.tar.gz"
  mirror "https://ftp.osuosl.org/pub/clfs/conglomeration/hfsutils/hfsutils-3.2.6.tar.gz"
  sha256 "bc9d22d6d252b920ec9cdf18e00b7655a6189b3f34f42e58d5bb152957289840"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f357724a46995df877e649f9ade4afb97b78e4e8cec503666a8423343d1589b" => :catalina
    sha256 "980dd894478cfc6b12f76b56dfd12996218af2ea7aa4a14503e11865364b2cab" => :mojave
    sha256 "1a0fd0b0ac3529aac6c79b1f3b15fbeefa2cf05838de439929b8c5c61d49c077" => :high_sierra
    sha256 "4b9c18851c1fd5ce7049946cb583d4f8336c29bd48c76690df707c768a2879fd" => :sierra
    sha256 "61847361f9dac3c719ae8fb464fb9e45d7b64054c7d3c2ff23b37a698546f63d" => :el_capitan
    sha256 "2d0997b77b2bc7b3a0454c552c6ebd3b24c6efc01bc9e4814781f7971c8802f9" => :yosemite
    sha256 "06dddcb4d540a24b63b389213724b828f99bfc7c32272be1a9e4ca4472409c93" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=disk.hfs", "bs=1k", "count=800"
    system bin/"hformat", "-l", "Test Disk", "disk.hfs"
    output = shell_output("#{bin}/hmount disk.hfs")
    assert_match /^Volume name is "Test Disk"$/, output
    assert_match /^Volume has 803840 bytes free$/, output
  end
end
