class Dterm < Formula
  desc "Terminal emulator for use with xterm and friends"
  homepage "https://web.archive.org/web/20230125064301/http://www.knossos.net.nz/resources/free-software/dterm/"
  url "https://web.archive.org/web/20230125064301/http://www.knossos.net.nz/downloads/dterm-0.5.tgz"
  sha256 "1b91db06c4540e58bc926c3b9cd60bb21d7169da8b3595e3b4bf9bfb2c7333c8"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0fc60ff39f0721d26034829ab0be58b0365d7daa69c45b3ba7e4fd08d4faa9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3ed01df00b32efe7a637e827ae2aec70a6d10063cef2128b7246a58f4f1e7a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f26bc52d3523b70ac1265b8b04fd739a91988cf3841b49d837efa0561a278045"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7da6c39a5a9edb1ed37346d39e2ebc40f64733f1607ae6290c4c3ab063e3b00"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a5265a16703cb70e8ba6d2bb380d87ab4fbd27c162eb1ea2d591202dd3fc7e6"
    sha256 cellar: :any_skip_relocation, ventura:        "cd3012cae88862d3935972cfa4c93b64ceb5937f4869656450f81ef7797009b1"
    sha256 cellar: :any_skip_relocation, monterey:       "9cf6f95be0d2fc679fc8776dbe5fac91eaa9b1671d5dddc86ce75cfc43364aab"
    sha256 cellar: :any_skip_relocation, big_sur:        "2766f4a9410153b28253e43695ba07aaf1886fb63747837b609aa81a2f46e5d5"
    sha256 cellar: :any_skip_relocation, catalina:       "0ee11ec243e1d9038a5f8d0ef86a00e5bf07af59be0497e8b8b677bf032bdc2b"
    sha256 cellar: :any_skip_relocation, mojave:         "d6d5d49c0e4da6bc6273bb8cffc0717daea8cad68346c34d9beedcbe0e5b24a3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "85085f6142348852c9a5efee30a697fa6b31d9162807a256aee5100e50ff99ea"
    sha256 cellar: :any_skip_relocation, sierra:         "a0f9f7bfcadc790624975724244e30d4459e0eb3172dc2646db2b58f7643589c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6e18a2f46faa55e99fe070c7fd5e95940d66a5295f694605c9e90b416b577d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32e1bc798fb4622c7fc33cd62f36fad897329075a8f738708fc319c08e82505"
  end

  disable! date: "2024-02-18", because: :unsupported

  on_linux do
    depends_on "readline"
  end

  def install
    bin.mkpath
    system "make"
    system "make", "install", "BIN=#{bin}/"
  end

  test do
    system bin/"dterm", "help"
  end
end
