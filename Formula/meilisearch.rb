class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.10.0.tar.gz"
  sha256 "1421acf5a356b317f9730d7b9c8886dc93df672cf08bd59549f9470c93236164"

  bottle do
    cellar :any_skip_relocation
    sha256 "de2e8239674770701b5d722f841fb99a7f162a503af2c03094d26c824e43cd32" => :catalina
    sha256 "b41b15f7869f474545a238efbe7d5b9cdb83a94b649bc7259f707e825cc081f2" => :mojave
    sha256 "0fd1d4e3c8ea26d1427140cc4fb94dacf817eec19288c9ffc6ff9ec417512aa0" => :high_sierra
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
