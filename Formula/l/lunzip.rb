class Lunzip < Formula
  desc "Decompressor for lzip files"
  homepage "https://www.nongnu.org/lzip/lunzip.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lunzip/lunzip-1.16.tar.gz"
  sha256 "f13809a1aeaf953f32b07f822c3804bfb11056c08d465b93750b4e45190becda"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lunzip/"
    regex(/href=.*?lunzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dc588e22b50b7d39507443df148d8a2ca055e31ed8e7d2a383b701f8006537b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68207de85c6fd73a7d36e1cf7994227769563cbe21eba7bc15209e0f89ff1750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52b1fe664ab2c763dd3e1a0ab348904e3d30ec35ee5aa89aa80b9109386380e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa8baefaf9f55a75e2e246bb53bacefa5a1a4676e3a7bae517679f66c8cf352c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab42bf3c8abd80b7b029d15ac4e366aeaea557890b6f600311ced3ee6590177c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6121f21bb49d13bb7542984ba53b79ed66534bfcf31180b3da77fc4350e35ab1"
  end

  depends_on "lzip" => :test

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system Formula["lzip"].opt_bin/"lzip", path
    refute_path_exists path

    # decompress: data.txt.lz -> data.txt
    system bin/"lunzip", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
