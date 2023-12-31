class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "1c13850d1735aaaad6e3ff0281ae8ea5868c6a08de04c2c3ee163cadf1dcb434"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "353181442c4afe18bd3bff7a7ad8a88ab7b0114dd37f2331323edb1e122bbbbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e21dbb5236ed1d28a3674bf83c957dfb1de3a9959f00ca838555be3e8e7d8713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8b1e22e49674570ca26b92668dde89a05929b26bda18771257c3f52c6f4d9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "35243bc51735c8a4529ec02f690634b45e3807adf1175b76085272647aa589b7"
    sha256 cellar: :any_skip_relocation, ventura:        "03f2bf37e901afc8f5714052176bb0bcd33bfe0b9b93a83838790221bef88d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "b9fd4e2ef7031cb65acb1443a36d9b05f11d8d7aeb6436f42a0a89be3130dbcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b5acb55ae16b48de98b3f725a9554cf2fc94f810700c3360198908876ae90b"
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
