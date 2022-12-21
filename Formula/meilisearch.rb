class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.30.5.tar.gz"
  sha256 "56b78e31fab27daf1bed305e986550711d219be9392979b7c98aee4dec0d51b5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a30b470e00cf3bace39aacb4d2a0bb4866128dc320ed4489360e22f6b7104942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0236f6346f5717edf9d2e0a84d288e8974a1023d5fd565a779693aa0503c17d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "826ec4159313ba767b638252bfd92b952cb538d1d004f1a5064a1c025d90857d"
    sha256 cellar: :any_skip_relocation, ventura:        "913a1922b24001fbfb57b12cfc2a56cca0c6302848550a918ca956de09c4db4b"
    sha256 cellar: :any_skip_relocation, monterey:       "ea58bf9f28a61c60a8fbf2eae85de3a890f217be44e4b2a3f6961cf3dbe58b43"
    sha256 cellar: :any_skip_relocation, big_sur:        "34fa8e3bcfb613f529259ae46ae8dee39d80b260e315792ec985738ff524ea81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0ef1f315abee9c1c783c91e4ae4889d6527606c38e136ec6fe440b0db48ca2"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch-http" do
      system "cargo", "install", *std_cargo_args
    end
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep(3)
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
