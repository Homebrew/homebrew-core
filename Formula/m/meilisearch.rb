class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v1.3.2.tar.gz"
  sha256 "aca49ad23eb21a9f5c86afc20dd9058c15a7fc6072c98eee3bb0891862c80336"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeb9f7fd744e39a034052919a033ef6ffd10f376b3d159b271f223430dd30c53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e2a2e9e75de63ae4f6c37f505d057668648276d7ecc0919e495d976e673f072"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c273c6e5f32fad71ec3532fcf037cc1ddc8cb19b0d9452384658c1be6465acb"
    sha256 cellar: :any_skip_relocation, ventura:        "485f7098a2b9ec1e0cb50185fb3a12bd06cb38802f70d74447e9105d0806029a"
    sha256 cellar: :any_skip_relocation, monterey:       "d5974ea6b184836b5b59d8d16841c4114fde3ba6db13c191c4e07603f8fe69f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dceeef82ce96db2a34c50afa8dbd86f62024972e96b42c6be59436fe7b46dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6184cc4616d5d96b1078c68057af026069c17686f08bba49318394134b9b67"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
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
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
