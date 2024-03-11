class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "5a7a5dd79e772ca1308afd8d92dcd3b5e546906fe01d30978783589133a78b77"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbe9f5e6ec34526753ff05ef465c60b5bee39356eda052a8a1abd6204356e2b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f941a200f7e7c01f43a65e577c56f4883e8cf029d0281dc0ddfa25941244f9af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "856cce406259d544f8afebd2e0478b0a37a8fa9b378e9224e5e665bb4998619f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d7203aa79348f6af3bdd5b960398b20e5909a927ade61906160e80d65c94a46"
    sha256 cellar: :any_skip_relocation, ventura:        "aee0cb4473e095791046d18b6a7ad68e90ca5ce64f1cf1b3745fb95a57c08971"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b39696e4a9dd24b3f50fd68f0484bdbf56cb2fe16f19b25bcdac1302ed36a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e54580b356e6d298cf9e34c3e056c7265ea3d8fbfd8ace1d345049d538277c"
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
