class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "f7d5a7ac3fa7a200c2fe32f9c9d75d778fbc5ac4cac75296085c4a1f2a50328a"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24f43555643c260e811c2fc419c44446558b5498f7b9f0b187cb6a1a14e340ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6500c3daeb82695cf66d45fc9ef927cbbf4582e83ee10ab59c932757484c18e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "044ef4672833c12b659b405b07a761c1de6dace74ca7a8a220c9ea9809f86eeb"
    sha256 cellar: :any,                 arm64_linux:       "d26e60f6780324fad17a7683a1b86acb5365f033ea0fad9657e485547dde2ce9"
    sha256 cellar: :any,                 x86_64_linux:      "ecc0e94754bfe205c3451942f37f4c56ca30d76385d1977afad188787d41adfa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
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
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
