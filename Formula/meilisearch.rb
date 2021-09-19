class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.22.0.tar.gz"
  sha256 "26539042b75f8e9f990a90d0567a65efb6471f5bbaa9e8229e5df090cc7b9ccd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "50a720c446745df81905222bcfe2201e4e81559baf8e085aeea42c1f987d2f15"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca41abb5b73e1485866ce927d4f7b9dfedf7f784ef9e2f4c6b7012981f262ad5"
    sha256 cellar: :any_skip_relocation, catalina:      "90de8b725405d328539502af2d3cc4315ba527846397d415877a37b9effb066b"
    sha256 cellar: :any_skip_relocation, mojave:        "ec908e597cbf3fad2f1b331bb6989f7570ac2e86d646c944276b0708200ba784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1db9a5e13ad1a69ca55e40a9764615402905d46ec9d14b53dbf57f5d3396a2d8"
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
