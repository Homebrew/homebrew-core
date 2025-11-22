class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "7c2d148a8f52c5cd12b92b7dc2ba2db1238d09cfcdb4fb72a3f4856f5ed1093a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ebcc820d0a957ca4d50adea1650e7d860842ba555b5a4c6d1acd80581a4ff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fad4e97c70e039a166f9c1b960ab77c050b45ecdaedb2201f4cd8a765e3c8ea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aaa97c8209413ac826f23e030b2587cef19a2d7e6f169ae5e9c96c4bf866e78"
    sha256 cellar: :any_skip_relocation, sonoma:        "855ff4898507ae11b5d75b8ad9a5b9f251e053e0008e5570c91a3a5cf996c93b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1d3143710e62ca37b1463f68e8bf0b27ab28d0efba6e6d363b23333c34dbc32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4629fc4a1e0a4f81913992c0157d056da7eff62b08a057efa9f771a02c1ad946"
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
