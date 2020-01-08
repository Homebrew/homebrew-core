class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.1.1.tar.gz"
  sha256 "71d973d829fb23a13e738e9f2b6ad3028e74fd1b57f1f296a8ebe4c32252294a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8b81e7bb03b848e622600a5abc5925bb5176e0f4d2030079be9d5fc4af22757" => :catalina
    sha256 "9f288e9ed076af79f677eda57aa815b327c8ef90eae9b970516a1f1d1aead59d" => :mojave
    sha256 "a4bfc6b8ff57d36e07a933e886a0463b5b1022ad0c455a09a465aec4a19b8077" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
