class Lunzip < Formula
  desc "Decompressor for lzip files"
  homepage "https://www.nongnu.org/lzip/lunzip.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lunzip/lunzip-1.15.tar.gz"
  sha256 "fdb930b87672a238a54c4b86d63df1c86038ff577d512adbc8e2c754c046d8f2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lunzip/"
    regex(/href=.*?lunzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee545b7641e3df03be2ed317246239ec92a16537e2ecd17ada8a338725c5e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2485e72af992bc5c7b2cdb9be3383c1aeb9bde5f07f35e17964d8ba962ee5f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f3c9cc0617cdea5815738623129348ae40566793c31c1d9d2788f43f32eb5a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f061dbeb231b41011d5c925239ec0679c7456eb9242bab6155c55553930bd7b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "71198791087ef6380858c64097848d8f9d8860e65fd6fbab3fa1c45e018f39b4"
    sha256 cellar: :any_skip_relocation, ventura:       "1a41f6efcd7b83a0ee333075ab595c66eabd0e7228ee2fdd3629d34e1d474d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c3ce13001ea04a7c88a7611cb9f2447bd2cbfa654cef5382a461b42538d0218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33207f9159131abd7656dc1f657bca8a18b90853a83f32506fa82996296d265a"
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
