class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.21.1.tar.gz"
  sha256 "b924ca9e9436db56a07eef55025a2e7a8dcbfbba7207fd2f45beac81aa200501"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27bbe5bbc3a4f93b15240ee8303180c6d7dc5b9b195152122a0889d10e51e71b"
    sha256 cellar: :any_skip_relocation, big_sur:       "1266c6ebcfcae9676d0166f145a5daf5cbd23c66ed693d7d29912d72407222bd"
    sha256 cellar: :any_skip_relocation, catalina:      "db4732ab1d648d65555f810ddec93da00eab8d2228e416e1d79b9965acf48043"
    sha256 cellar: :any_skip_relocation, mojave:        "fcad2c9a73787f7277f0ac5cf8a8175328be1eee053ecc08dcb237b5a6037945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a31d13a7634b127a4ac918383f773a2685732c9c8b4c5b17cf75e493d2bc08b6"
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
