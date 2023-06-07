class BatExtras < Formula
  desc "Bash scripts that integrate bat with various command-line tools"
  homepage "https://github.com/eth-p/bat-extras"
  url "https://github.com/eth-p/bat-extras/archive/refs/tags/v2023.03.21.tar.gz"
  sha256 "27d6b5849448b7cb76404f549f89def9ea1d5adafca85ad39daf25e9ba6ed907"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "180b566ba6903951328b1008b7165163c61ec953c455d06c7842fffd61a2ebcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12ee5e6a03c6716fd5e2245509735b0ecd10992fc1048b22b8ec31bfd53e50dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e1027e859b4de14a88db344f6137435c7764c90dbb7de0ab50fb3f593469ead"
    sha256 cellar: :any_skip_relocation, ventura:        "31e9e91de64cdb1f121aa6121109d9d4663feed0dbd0b741f759d38dafa5e2ad"
    sha256 cellar: :any_skip_relocation, monterey:       "bda0b3e6544d2e9e4b5a4c14111e36e2010fbc41efc39d944bb98bba324931d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "082cbc509a64487d5039360379861f3e4c142d00e5cceb3817342a88c7f1aeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de25b3c6bd6e9a6577c451221c040f077833770019566c34fce6e2c6d7daf04a"
  end

  depends_on "bat" => [:build, :test]
  depends_on "shfmt" => :build
  depends_on "ripgrep" => :test

  def install
    system "./build.sh", "--prefix=#{prefix}", "--minify", "all", "--install"
  end

  test do
    system "#{bin}/prettybat < /dev/null"
    system bin/"batgrep", "/usr/bin/env", bin
  end
end
