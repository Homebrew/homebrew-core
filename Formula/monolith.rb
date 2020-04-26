class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.4.tar.gz"
  sha256 "b2604ee58c5b81cf01f01f8984cd2ff80c5ec56d93aa1131ee6ff88b95767af8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ad8b8afe92fb3f7b972331199937e40c72ea94a0812bf778449d545eac64430" => :catalina
    sha256 "830dcfb9397ea69c040396adbb29130cb09705ea20a5ae607fa92af0ab57361d" => :mojave
    sha256 "b9671d20cc7bef311f3e95741c721963b594895efc0939c0045507bda0a33da2" => :high_sierra
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
