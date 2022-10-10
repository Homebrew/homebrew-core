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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5356f0c88a86cdea80610456a08f4df232bb691bc273a1b7407513bd40a5203b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aa97db90e6cf489b89ae6dd76ba2911ad81e944857ec512adb24da4ec0348e3"
    sha256 cellar: :any_skip_relocation, monterey:       "a82f844f26e4d6ee6886d4ae476eae37d949d1b4c1b3e8139ad90662d43ac1e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e58ae23d1d59cae97c9dc250bdfdb949b13fc5bf3b3363fe96ed8559ad1f9d8"
    sha256 cellar: :any_skip_relocation, catalina:       "e98c7cd52e82974e07481bbff84d151b03151193e9171fce4499d34942d73849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5225853ce6389d2b2392b92feceaac8f4198b1776fdc440a581370011ee2d6"
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
