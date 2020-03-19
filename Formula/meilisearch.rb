class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.9.0.tar.gz"
  sha256 "61ae632adb8dd8307f5fd362ac348404d6066e7f4cb93e36bbfd8648f58e9cbd"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c0cf2771d4f20ac3d1e48e92c5d5e8e2ef9306b0d3689b45e87c2db064dfddd" => :catalina
    sha256 "dc832f214ea74897de8b6713bc6fa0e037209af0823770f3c6a7e5206c3394a4" => :mojave
    sha256 "f1e152cd4e0856051e2227ae869ff37b11181f645b5c544ffce00c035d8ce252" => :high_sierra
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
