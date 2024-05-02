class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "4e3b2ffe10ee4dfadedc61de877c5cc8ff388f87b98ee6d491dd7193011a7e74"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e874761f5faf770adc28796cab3f440bc14a988a6a6169681118fa91e8d41cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dbd031fff428c03430321ad20555e2a95f09c920cc2b1d189d04d931c24a9cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37c295b55c7a3aabbff97fc3cb2188c97504a1306b5bc5e4a430cda29e092f80"
    sha256 cellar: :any_skip_relocation, sonoma:         "594bbdea2d2f4ddca7161ecd3c31c9e962db6de6c4048349bb9d0a15d7226208"
    sha256 cellar: :any_skip_relocation, ventura:        "3719f7cd68ff431c9545d4063d9cc190cd32d21ec86966d065a65c503494f58f"
    sha256 cellar: :any_skip_relocation, monterey:       "dee437745cf67fdc396a15a074fc20e5ce65c23a26e642518d6704bbce34c4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2118bee70cf4282141818d0fee7dddd8e9b2b6b66a4202ddfebc08f0017529e7"
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
