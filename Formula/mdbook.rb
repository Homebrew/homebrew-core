class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.18.tar.gz"
  sha256 "ce357327f4443189fde307103f8008f43410ca8b738c5c61401ada9a54b8b5b5"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee63c0b93ca558f7e6866b5d752b617eb8aabd5e1a79ba05e381f08a8c0fc187"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f46c00dea5163cc40adb861248e01c6fe9a29e094b9d42cb6a6ab932f4572d02"
    sha256 cellar: :any_skip_relocation, monterey:       "38a15f8c07e0f4b63025ac13d8d5cf8ba7cd5d2a112deca0db9ec77ea3e4b08e"
    sha256 cellar: :any_skip_relocation, big_sur:        "73c38bb0f5e4994804e47f2c63fa4126a75d3af1947f76d9382d961334f405aa"
    sha256 cellar: :any_skip_relocation, catalina:       "cf75f89b1728855d33057e4e97e3b86a9351a498513c888cf739263252df45ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a9cd604a4b2059519e425a92069b9412ccd5b2364df92f83c36e083f6cac1a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
