class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.27.1.tar.gz"
  sha256 "115caf326062c341308bcebacd72ece1f4680db7f3791f31e8eb300d6a0ee29c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22aa269cab979cde6cfb78f090a2d6f8e66db052f1f6a84c417875ccfe85adcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c530d626d8dc9a11e5a11cb4500530653836bdbbce5aa593e332d29a50809a38"
    sha256 cellar: :any_skip_relocation, monterey:       "1684f100270914256d79d67f8c2cfcd6a3bb3251bb14366e6c8d9f8595d8cf26"
    sha256 cellar: :any_skip_relocation, big_sur:        "010a759a8af1a46671f5e9d61cc5679c1a3169bf70490a4b983e61560d31b940"
    sha256 cellar: :any_skip_relocation, catalina:       "6abe271f8ab9baf20f663746c5e15a256905e033e8db740b9192c235c841f35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3bdafcd27f0b3345ee538929ec199367f06c020f8dc90bc4075d6f7ef352921"
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
