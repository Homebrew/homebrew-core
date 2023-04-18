class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v1.1.1.tar.gz"
  sha256 "59511c16ce76dd497d9d5b56250edef83e0e380a0f3175d84b612041db019be8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35c9b3bc9bef9ee858aecbb6b023595abd9f35f0080d619c63f72b5e216389c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60658511a6cca669499b2c90d9f0704fde35dbb7d423ab1f111a7e7824c32743"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e7603f966ab18c2ad2d84f1885ebc7c1b3452ce2798da1cddd3347cb0a3e46e"
    sha256 cellar: :any_skip_relocation, ventura:        "49b5918893bd3ad838e2ae7ed6b075e9ac404b5c7b1327ae19d7b772c71f2a62"
    sha256 cellar: :any_skip_relocation, monterey:       "9d8717b260e9bfe2bd36f095e4dd7a5ddbe7546ef57b8a8f2ba442fcc47dfa88"
    sha256 cellar: :any_skip_relocation, big_sur:        "a781f7af8d9a6c9db9e19d7eafb15c952270757ac5a25f2fa44cca3a14a20173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8480b203ac7da80a7d7f8a594b138556ee7335f1f9926f7b566bfa14cbcd3adf"
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
