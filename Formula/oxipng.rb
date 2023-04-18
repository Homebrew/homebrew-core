class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v8.0.0.tar.gz"
  sha256 "ef96d6340e70900de0a38ace8f5f20878f6c256b18b0c59cd87f2b515437b87b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab9167d9fac2985e904c86f32e05266b7b483aa5eeeb921d29b83afece4afe2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "def19daa9c66adcf5d92dc3c71f2b531af46f637c1d8f567ec4812fb9e3a1138"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "836f09e119c031e40473101093003cca4ec659403d0a647a029749eab8c65518"
    sha256 cellar: :any_skip_relocation, ventura:        "2d6a20924a4a07e48b5afc8d5878ff82dee29428551e9b0113b02e1c4a66b31d"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c0d211e9db0033ea8de501ce95463a2c3845a782cda6422fa91343a5cc1c58"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ecc4ad6e44aba3f42f0f935f415d6d264ec0a8bca1f4169a174cfe330b32dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b02dc75713930b03e7a89ceae1809e5e1c0404dc574d8e70b8ef0441035a1dd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
