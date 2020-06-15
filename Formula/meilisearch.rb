class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.11.0.tar.gz"
  sha256 "401767642927493e82259f2e86ead9114b2f7ed40aa687dea5ce9b8ea886c62e"

  bottle do
    cellar :any_skip_relocation
    sha256 "495d6ff17938caf29a6fde833a3a83d66828ef8a88d67961d7768e9f096d069d" => :catalina
    sha256 "48bb47eb4144fc257f24d376a157cb2cb2bd001fdc0d4da649313d8ae9f41469" => :mojave
    sha256 "16a5cc7f704afa4835705a612fa2e0d44d4bb642e8b82c375d2736d94662806c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "meilisearch-http"
  end

  test do
    output = shell_output("#{bin}/meilisearch --version")
    assert_match(/^meilisearch-http [0-9]*[.][0-9]*[.][0-9]*/, output)
  end
end
