class Lunzip < Formula
  desc "Decompressor for lzip files"
  homepage "https://www.nongnu.org/lzip/lunzip.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lunzip/lunzip-1.12.tar.gz"
  sha256 "e55b4aaac5666b6ccad8459e52f8adb6869ce259f686e960129ae1e1bdf52ad2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lunzip/"
    regex(/href=.*?lunzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b92566d6e454e92eb6733b6028126945b9b5103da571e5baacafa96ce9033b70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e4a5428378440f10ff995f1ee3b1a77ccaff3b1094676c0b71ea5da6fd14e70"
    sha256 cellar: :any_skip_relocation, monterey:       "2b23b4b4faf28c23373cd9e1d825172a51672b7581e8b15132c5883f9be5ff10"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc114966f582d1ad76ebc12d90a41aac605c59c7588eb5e08c172018dc11d214"
    sha256 cellar: :any_skip_relocation, catalina:       "fa648ae46f4217291d717564a124283340e2cdb51da563ca8f0bd0736282bace"
    sha256 cellar: :any_skip_relocation, mojave:         "a4e1358d0a41008f763ca03ef69b33b68f1fda5f324f234e8cfddf091a12923f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0754449246874a2cecc5d63962cda9db3c87c1ece9152ef6931d06874eb17a02"
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
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system bin/"lunzip", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
