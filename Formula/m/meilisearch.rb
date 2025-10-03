class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "ff7e195cfce2fb233e0428f8178c00cfafd99fac8f96f9c618dfa80aa695e5f0"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "841f096e70d2270e9a317e5d7c1e19a636c7e3aa3b3c9de49dd27a3392858e8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "749923b3a193d318ef09a50bfe2a71d2e2496c5e1773972c57b59f67989d32bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0db44138eb1e7dc854ea79a623c4675787fa3dd70c754546692d2179061f2c6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9f9da3b1497377942070144869f9aca098fb50591dda9d93bb684762a259b2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f73d87188d02c94d3178427aafe274ed2c464072a916624dfff4e31b006acf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba007ce0a90e8e09f2772452a06d9a9307bd80f5c02da1552cc2a6187b92883a"
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
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
