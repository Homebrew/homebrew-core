class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "2b2b49d37ace92e6d4c36ffe548c7417c4a563d028b3452cdb42b646af98218e"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30a4b1eaf04530f75132fc408ec9776cf072bd5fed989f01ee35673dd76cf1b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8218a673a216efcbcce1250ee59fd5a5e08169eddd6eefbcbfd8cceca1cb889"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3755a75dbc5549da3623b8b6f441e78586be3e4783a6f1339cee9a64587fbac7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e9cd1b59ea5ebb302babd6ea45117ea82b7ee3118d05f7a45cae5cf6c45dd00"
    sha256 cellar: :any_skip_relocation, ventura:        "2642eef7ff492d57210cd334d55ecd04e53087a91bed63e7cc7557cc5839e096"
    sha256 cellar: :any_skip_relocation, monterey:       "af51ac1f65ea52b9eeadf1d729dbb2c50421e5e59a0b2776e26ba5ae0e10e30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2dc83bd6a620f0a6b1848391b327cac47d6ad6a0f1d7a9a573fb2f32176d988"
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
