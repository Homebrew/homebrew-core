class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "bc1be12f4f1b050ab5ae7beaf2c3b656529165ecd2095d33c71bde61b781f933"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7b166cc672fa55b78730ae279a57295720aff8dd40188b0d14805b6a87310b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0cf411d8ab749dc37eba336ab869a4c4f3d5ad76d8a9851b269e0420b6a902f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be55ff47e435e53a8281f55af912f4759983e414858e267e732b61f6ce8adee1"
    sha256 cellar: :any_skip_relocation, sonoma:         "baac7a96b2998932b417eab37360d9db5b9fa8d817131a44cfcc489132169951"
    sha256 cellar: :any_skip_relocation, ventura:        "ed56c90c4ef91a595c2b91c42bb6f8f7261c914eab97be9e41e9332df96f484b"
    sha256 cellar: :any_skip_relocation, monterey:       "67e3c70235ca3eca7bd4aab0a49a91aed7271a8022e989726153ef24b82de024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0b073fac5f6964c706e633d2ed0769d189c7cc76862ae269920b167412d613"
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
