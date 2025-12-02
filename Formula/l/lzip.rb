class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.25.tar.gz"
  sha256 "09418a6d8fb83f5113f5bd856e09703df5d37bae0308c668d0f346e3d3f0a56f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/"
    regex(/href=.*?lzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bbf8b41250a6b85edf045a0febfa5d398f7518fc96f26f6db92470b66e121a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc54609160314b30e5aed34e8d2a05fc49850a5ad3440837aaf99692bbbbbb6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b78f49d3c8ac2bf3247ae3d1940d221f9d957a2a1440c64b2350e864ce9d7df1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5b0a4e60ba4c516752d4f3584be960eb6f5403669cedf58b91bc37b4e312d20"
    sha256 cellar: :any_skip_relocation, tahoe:         "afdaee704d571bfe3255ac40e79725254e68dd1f24ec212b01e97fb8d24ab917"
    sha256 cellar: :any_skip_relocation, sequoia:       "4340cae9c90716b62b003cd132c85702875e8ee904e91043d68ac78d68e6b830"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4e8fc78d0c7151b6f22ca94ab07306a693bf0ae7c1c9e8ee0850c118fe5339c"
    sha256 cellar: :any_skip_relocation, ventura:       "ac49101bfc627f72d28324f6bd2572c5ece36e1b3966e345407220573e68b426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0621b36f1732ed0d6c39a932dc5c9d5f137299c45e2c866e8f5630ccc7fbc7ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "308786bcb638bd26b84aeef239c9fbbd03c221922bcd2cc595fdc9fd2a3e758f"
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
    system bin/"lzip", path
    refute_path_exists path

    # decompress: data.txt.lz -> data.txt
    system bin/"lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
