class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "16bc9010f6a425ffa6cc71e01ab72bb3c9029f736c30918bff70157115b3ae9c"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6706f0c92e08ef9a6ddde3909affb08c2bc73a182bba2743d9a749f2d04d1d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53c97c6e153e089a3060cfd56e6cb3ac0b905acf04605fdd2504d624d61690f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eb4b854965d62ff6cfa4d0dca120c1fa260c170763dc242afa43b36efee24eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b5fa9d548cf64fc872b6507abe24648215ee6bb7e6b9c1ecc8d0eed30aa53fc"
    sha256 cellar: :any_skip_relocation, ventura:        "4ee9e494db43ce35bb963af6784d6ce3fdb99a5a5c8a381c0665cef324e6cc4f"
    sha256 cellar: :any_skip_relocation, monterey:       "9d0a0eefb85a3193bae463e17820735abff925de23c2d9ef63ef3b870f6ee31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf5fe1cfb7273562ab9ab32697e869cf02f2e33cb85dda48b70c0157229c13d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
