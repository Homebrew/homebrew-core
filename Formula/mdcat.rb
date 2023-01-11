class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-1.0.0.tar.gz"
  sha256 "9776fddd6caa835a2b01a32bdab08a005855a2ce18b530da35ea95ddee30e0fb"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cbcbd87a03086e43e0c51d1f066e3b62a5ffc665c33bba8eac08668ebc2a6a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e0aea8a458a5c310051a7e42de79810bd9b600d26a0288c0eacd11043c5033e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c3eb59380be76de82ae1d54e8fae7bf337b8eee8148403b4bdb2e3c6b35db57"
    sha256 cellar: :any_skip_relocation, ventura:        "4b562d9262f382996f8b4c9cf747b89f21ac1e3ac4776f2937b995be8a04b6ab"
    sha256 cellar: :any_skip_relocation, monterey:       "ac0fcbf5bf18b19d826a3a72690bde101f64f503d39856fee10abb2ba7cbeef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "73b852c7cfff71779f0bb3cc152c6b1829b0cc1499ea9d3d660ed96d960ddde6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccc0c8d5754cc4cd2b385e6bc34e9fd52ff20400721b5a54aea259f0cf63a2a2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
