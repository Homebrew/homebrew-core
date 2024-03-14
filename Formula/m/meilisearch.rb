class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "5d60827c5c8c9087387f588b2d8ab3496361c10ae460025a33fbbcc524e991f6"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30abb183b87834225d80b17fd184b72becb5394ca6e1d52c4d2fb43b8113739f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cfd6431d91c20667504b985c3862fd3feed647ef95329522e12eb7d08af3e28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b21866a963b073cff94c6f4e4b4c394d9b5abf6ff10b0122bed52782cf5b55cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7f93c0cdb4ee42673cc9eb2cb291ff6ebd4c4cfc00b9f80ce9f9f1dfe0a1d64"
    sha256 cellar: :any_skip_relocation, ventura:        "839a043ff8ea7cc551faad0447760012e3624d43c502f0e943541e0e2f61a88e"
    sha256 cellar: :any_skip_relocation, monterey:       "074b58d78dd3c0b249b0d858699dbaae2cb99a4e815b55312a2249a7870ab14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33424b008652b20f86619ed87a5969c2902caca6583e641db23ac64ad549b6e"
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
