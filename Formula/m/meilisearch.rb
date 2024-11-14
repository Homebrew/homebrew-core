class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "09b080dafbe9e08d9302286ee314a0041bb751f4639b0a9bacc77969ad51f9ec"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcabff7332ce13bb9b98baf67eb341ca46b818b71703164b6b1db7de2b9b62b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "974d66b397b3db2203643ac89bd541f03e7055957f3e8650609b92d29a550d38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2db9805bcb9a97c1a34254a29f60c31f067e7bb3c5fb979a85318e7e6dd0d06e"
    sha256 cellar: :any_skip_relocation, sonoma:        "150fb6b4ad1b99dcaef653f2d420f31ee796d165886ec6d428fbc5ab7608d9e0"
    sha256 cellar: :any_skip_relocation, ventura:       "19bee76f9d581961cc4d8888949119c18e06ad60500d55072242ed4586759207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d1e4b48676b6efb0ab889e95585e16f7cc2b163d5daf6385a3be498984e5f51"
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
