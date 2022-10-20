class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.29.1.tar.gz"
  sha256 "0c45ac53af46626d9bc0ad7c1f4834ab715b0cc8b605e6c065a9a939faafb226"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c16b05666090c76a2c4fe2b3167886fb27a33eb1597aa554217aacfbdac97c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "302e85ea4342ae1e7c039ff1233a21804992300f870d5aa696c2188e4dccd994"
    sha256 cellar: :any_skip_relocation, monterey:       "c24db218e988a351af4bd99065bfe961e9f8d31485c684ee94ad8688b005e9dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "52fc57a8d12f6764f5476fd0e3dfbe46e6665ca232c67030fddda52d3ffdabac"
    sha256 cellar: :any_skip_relocation, catalina:       "b1420ebfe2f3edbf0b2071dfffc35afab0ece5ec814cf6b7341ae1f2abf81014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b8ff47629a937c1a44f1b5c109832c3a362d5987a55f20fe5a3726f173c032"
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
