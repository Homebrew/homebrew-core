class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "6c01557d8a73ed2dc591d326d2a7d2b3fed5e4a14df77e52edcbe38294db65cb"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ef584efc6100521f68c4691f3f86003ee3ab918d40a8629e69f60d1d5ceda5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9ab9271ff14dad1a196a9831a31dcdbe4ed27e51a492cd47135c20cbfe9c9b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f55a3a570ab9208e5f801e994299fa6a49a7655d966cd54dbeb997ae385e10ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a81f333efbd4f5f482d3164488f06c0cf695d359cefb22a4a72f28d5f01422c"
    sha256 cellar: :any_skip_relocation, ventura:        "07b8b479cf744fe1b672b5f6c5e64ed4a485d084aa64ca68283c05b8c0e61b57"
    sha256 cellar: :any_skip_relocation, monterey:       "ac0bffecee583ce3eaa9f67f132ced179e75f7b7b1b927a2db773f36d76844ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd9a972865de2a3b30ae5794f43782a3fb98b8568420de9818d7905a6d77784d"
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
