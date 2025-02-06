class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "b61a4a230107566b956af7d72bcc1a23ae624128cbe48b3662f38a6e343f32ec"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85dd0890250179f2c72825c1c0dc12b1fb0531441f6541217a3848abe6c0365d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51de8b2a502b4d2ffbfd2cb44e2a75d148319f3c0ed07d4408bf9f297c004b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06341fdc7f4ea4d3c72279897f128ed0b3df8cdf334074a9a3a6036dc927c17a"
    sha256 cellar: :any_skip_relocation, sonoma:        "29bb2d95f3aa8c36f0b49a3dd51bd1b7401cfe5f00a9dfa74aa12d5ae6f7af5b"
    sha256 cellar: :any_skip_relocation, ventura:       "d0d6e76fbc1d78933fa8b9648f1e5d84b9d5094c5f56cc31da4c8636025057a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2095939b4f113dedb779186a20c18302a5d022b37210db0d8c29161ba5c887"
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
