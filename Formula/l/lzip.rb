class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.24.1.tar.gz"
  sha256 "30c9cb6a0605f479c496c376eb629a48b0a1696d167e3c1e090c5defa481b162"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/"
    regex(/href=.*?lzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cedc66b1c132536ca8ca9f71e43145286fd088c64c3c8c7f3217cf322cd190ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8391912d3cf85ed2531bac0f9eb32531b4523434731c3c2ea2bb8de7007c295c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7fd739b4a82c6bab9ecacc48253362f62c2c189b2a32498933a5d308e00742"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecadf4daab01694a6fadd95e2dc16b786bd7ff7c1ff39f760ef22c73ad118a7a"
    sha256 cellar: :any_skip_relocation, sequoia:        "d5405560476c3c590268cbe04219eb97a7be349cc9d52622c79b24557cb327b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3caf0d2d1f3bddd5c322549a01b89c36553f511eb35fc0b298374aa402acbbcf"
    sha256 cellar: :any_skip_relocation, ventura:        "c3e7d080510e3e05548b779c651013b3ef45183ac3b323a3a0ee521ecb71f7cf"
    sha256 cellar: :any_skip_relocation, monterey:       "bbe17faca2bd2e67e8180e6e24f2af642eceb34c42b1ca72ba6b3035924593ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63dbc62bef4272c1ff314f3e6d4a9e1a47cede9a1c3a07bc4a383b25100be044"
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
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system bin/"lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
