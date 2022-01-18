class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.25.2.tar.gz"
  sha256 "5097f0c6de042125561e669a1d9d09c4ee6425e9715fd0ad59dabeeef1b99ef8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72eeb5857aa49f897d376d543afa266eadf86723e5893b1121261a94cd041c49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7733022639e2bb6b95e9cd564ecd96baffb96fa10751fff584cc89d1db3da8d"
    sha256 cellar: :any_skip_relocation, monterey:       "c4a0fc84b692b7d73f808f2cf529dd11a44091f98acf8ca5c3700e891b42e613"
    sha256 cellar: :any_skip_relocation, big_sur:        "3869418dccbe55fdeb2ffb96c0eb85208a45246a531773161555f352b57959d2"
    sha256 cellar: :any_skip_relocation, catalina:       "089dc54516a3182dba3a4da57bdae8fd9dad556c358deac59bb21e469d2a08ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e10ecd1b56a032de09d98dad94a9b8b77acb764d7fff7d1864c29a5e3dde527"
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
