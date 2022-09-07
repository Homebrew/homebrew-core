class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v6.0.1.tar.gz"
  sha256 "02625687bf19263bc2d537f9f81f85784c5b729c003e9dbb8551126d0e28ba7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1055ca4bdbfa5cdff1d4cf084bf7e28334a271d7892d443b1b8ceb0892a60309"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "989ac0424081ebe862650cb53e1cdec933ff8b8b33d183348a111fe1f87062c1"
    sha256 cellar: :any_skip_relocation, monterey:       "6ebdb1c3cfe91ce94f5279b2746df7a4d09e8d71332df5c15f2d8978b7076372"
    sha256 cellar: :any_skip_relocation, big_sur:        "670844c3073e286bb16bd06a58f054ed1dd57a04b47c91e7c3e3e386592a6458"
    sha256 cellar: :any_skip_relocation, catalina:       "303f52271d3ebd838db74ac5bdff17c45db7f311a69034c513ee84f7a91492e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd5cfd86ef830f93adc741e6da8bbc0b4b8ebf86fbd63cb6096474bfc1aff91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
