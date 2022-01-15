class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.25.1.tar.gz"
  sha256 "e33d6b8568a14b7cc81060b8f42d784c077cde2059f0d2492784f71775612e96"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd2f5c1fdab0719b0ed56c70a1fbb01caf296c0c76243067457306d2f07c625b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fa9d28be657ba27cca52456abbdee9bac70f4478e056756180c82b58e06e86e"
    sha256 cellar: :any_skip_relocation, monterey:       "743cec870c22dcdb121c11ec9998d80b243d016b3441c57354181282db65c2ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c9f2855c8040a47931b1d3efb87ef3211e76686fa0eca61ccb2054b5f086db3"
    sha256 cellar: :any_skip_relocation, catalina:       "77a22ab3855cfc7f2a5e02f1e6ef1de41a0fb8b28e9ed3e3c2c509446d54f3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d3d020779c9ce4f9163175213ed4de92205d54ffc62a5b51238a19b949f3b6"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch-http" do
      # remove when version > 0.25.1 is released, see https://github.com/meilisearch/MeiliSearch/issues/2078
      inreplace "Cargo.toml", "0.25.0", "0.25.1"

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
