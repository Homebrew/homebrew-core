class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.11.1.tar.gz"
  sha256 "b4d4c4e3abd69e522741271dbd157c391cddf6f1609623a36179c476ceb8d809"

  bottle do
    cellar :any_skip_relocation
    sha256 "15a4f4952a166718930be79d03d67ce7a643302265086e607f7dcfa77879f33a" => :catalina
    sha256 "07226855122847ec49f275b33302b33d6fe1f659ccd948981d06bb0569e11fc6" => :mojave
    sha256 "19228119252c8877ea55f918ef260296b05322eba02d22d9d21e269586a956cf" => :high_sierra
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
