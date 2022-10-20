class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v6.0.1.tar.gz"
  sha256 "02625687bf19263bc2d537f9f81f85784c5b729c003e9dbb8551126d0e28ba7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64c7d8e83ac7657429b5cbb75325c415c4bedc0c334462504e478ce703a6d746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59ae76e9603847923229e462c114cd37b8547cfbc53e889c67dced66b90c9fa7"
    sha256 cellar: :any_skip_relocation, monterey:       "daf313743fd6775f02d088ae9984898ab3e6f9b7c597cedec86ebcf5d4d55b1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e7cdddf3d65e220529c20bcc7d92b4e435f855117a00f012baa07f2eea99569"
    sha256 cellar: :any_skip_relocation, catalina:       "e184013d39757544f2459041f0b8964af2135218cfcacdad703de34e073ee1b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d849fa2d01d46a6d6ce925882b7261d0d4a22794a026be19ae5a91bf1116246"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
