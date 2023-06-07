class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.10.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/plzip/plzip-1.10.tar.gz"
  sha256 "43faa58265d8b89ad75bd4ed11d347ef10065a8070748bc1ed0e06f191458098"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/plzip/"
    regex(/href=.*?plzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff197ed40748a9959d86f52011fdebef01c8b98621d0567ba505f2696f8b4f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ec189bc207195600ac67dc7bd8e1f45b34685f187829f20c94dc576530ed8bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be14dc090e8d607c81f0602104ca92d76c2a2dd041d822d2e9ca2e10b9af5c40"
    sha256 cellar: :any_skip_relocation, ventura:        "66ea56e716813b70de7b13625e71083aded3a4828575a8bfe6e452fccf3d1f52"
    sha256 cellar: :any_skip_relocation, monterey:       "84d7405ddf1f389d88272bc1059de5734a5fa3ad7c4e47bca93db44668f408b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "68bf6627aeaa0e6656deaf8022fd41e19529d0b6ba80d4f15063a6ad10d7d688"
    sha256 cellar: :any_skip_relocation, catalina:       "cbf0b83bef990c417d8dc4cb57a67418ad1891842d18d568d27f902fe299560e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23f7ed84c69053f4cb82d0666b15c566fae4989448f4f259a1cba4a81d7a9b0"
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
