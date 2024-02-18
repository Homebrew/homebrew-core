class BatExtras < Formula
  desc "Bash scripts that integrate bat with various command-line tools"
  homepage "https://github.com/eth-p/bat-extras"
  url "https://github.com/eth-p/bat-extras/archive/refs/tags/v2024.02.12.tar.gz"
  sha256 "53e1c43a0ab660a8f7b2176a9c89de17616d42011ad63f30e2793ceb0f8c6688"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28c25f890fcb7ac8a5005e2978a22b323a8576d260bfdcf8840dc66d636a29a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d80f2e74b58984dea7db6d10755fc056ec2e78b72826f533feda4fcb68d7f2e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d9fb45e615645b1961a60d109629fd49760d11bff64e4341e1517ebc3a9a91f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e16448c1541536e670eec467d86f9e8ec0e928baed5ce4adf91e3d66e844c360"
    sha256 cellar: :any_skip_relocation, ventura:        "692c1f6c21b1303b42700d8fe017d5daccdc404faf80b48582e1c39a49d85837"
    sha256 cellar: :any_skip_relocation, monterey:       "7079d6ef58054dc6bc984ade2c43cfcb99666c922aab1f1f24269e32d613c527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5992573102b28616d8ee2b6042c1021cbe020cbf6a25394ca3504747ec5eda2f"
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
