class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "c29c9bab6dde9a223dce7bc79280d9c815b069e194571c21aa93127cae7b855b"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "783100a04a04d6f1a1eabe763b16c999a4ddb242f0e887f2c8b3ddc42526d567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0755d18f4951a8c0ce5f77614598c48b9cb7b6ec8dc9995d378177d7eb07537d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c7ca45aced11c5482278ac15e522fa02a39ec3a9e286b7b281f4ed87f7695f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d86a20b9c690bb488fb7feece50aa7ef024146f783d3035b01590730b795ad0"
    sha256 cellar: :any_skip_relocation, ventura:       "c0a0afe31142f2221c5c7de07ee41bae8451ee5dcdf51b98ab7b278132b4dd90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad0fb5eea66340d9118ecdf7e8ea8a56fc488e8f35e6284f2c5d4df112849fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ceea95340f9681f0b0b91606f84497552f5210d31dc30ddb19a89778643756"
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
