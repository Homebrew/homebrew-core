class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "b5d7ddcacf1fe8f1ef20a8fb67b807a416345fcdf5bd3e8c23ded35ec19ba7fc"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59f915b52a5f5d86140b5a4f995fd0255b0663e1fd803dc79cce8232a6a21fec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43881433ecd8f6fc0ffdc7d212325f97e5da854123815aea369764e38291b68c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d731f37057361394ebefd05b98ba75125c8fd91b7011c924678f97e316f7257"
    sha256 cellar: :any_skip_relocation, sonoma:         "eeba989f7efcbe2fe14307bf1c685603076d21f638f0911496349028714b474d"
    sha256 cellar: :any_skip_relocation, ventura:        "bafd22e91a806bc9f6591bcd7f7181b0da59080f8a45f1d6b43d9c54ed16985c"
    sha256 cellar: :any_skip_relocation, monterey:       "24953f9ac4878e4ece44c6b236e63ee3cf354dd7ca27cf31bd1b4debd43386f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad5849761126c6030cb96de6428d2633ef342d7a293b9b83d95c33c88791722"
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
