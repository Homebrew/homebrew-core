class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.29.2.tar.gz"
  sha256 "27ecbc1d81a7a1206519e9221c1ed14f48d6cb68e011fc9fb59d54170e987aa6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7fc0cfcd5d27a861b3981ef85149616ec8bd0afd92c26b1513f44316ccc64d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f04af13271a9ffe065a3f6bc60e26a9471b86ac1d271bdca4488ef89a254a677"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90d4214dcdd6d01340ac9feae4744bb8cc9962d0f0e3026cabfe862e81e4d385"
    sha256 cellar: :any_skip_relocation, monterey:       "604724a5d0af43b397b5d35781c9d704ef46244a9ab21e1ccfd6e5d7f24b095b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aa09d5bd6b57170319e032b30f39c0f5a164e1adcf9836f5a9ffef72b085558"
    sha256 cellar: :any_skip_relocation, catalina:       "00526b1037aa97965f4fc41ff8a7a9a65fe8dde7386d0af66a9ef8f937201d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58966285f29fe8e7231ba5ff058236230f3e6bf9ef1991be0d8641a95bede826"
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
