class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.11.0.tar.gz"
  sha256 "401767642927493e82259f2e86ead9114b2f7ed40aa687dea5ce9b8ea886c62e"

  bottle do
    cellar :any_skip_relocation
    sha256 "15a4f4952a166718930be79d03d67ce7a643302265086e607f7dcfa77879f33a" => :catalina
    sha256 "07226855122847ec49f275b33302b33d6fe1f659ccd948981d06bb0569e11fc6" => :mojave
    sha256 "19228119252c8877ea55f918ef260296b05322eba02d22d9d21e269586a956cf" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch-http" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output("#{bin}/meilisearch --version")
    assert_match(/^meilisearch-http [0-9]*[.][0-9]*[.][0-9]*/, output)
  end
end
