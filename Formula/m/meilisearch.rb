class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "5db542f605cee31c5bec9be1ddb82c4dcfc4456b312ff1c20013389b2edb57c7"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62388bb990c0dac35de044f4cf770aeda9511c40b466f49f71af47cc33da3ed0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a19566e682605bde85924475dda904e8f67a7f5bd35bbf9b7e7f3dd50dab4e60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6238abd590e03b458ceafa90c88c973021dde981fc19415c450b88fb169cd975"
    sha256 cellar: :any_skip_relocation, sonoma:         "515c76e06699fed0f45286805f83f3c83131832a3ea54bd56c02fedebafb52ff"
    sha256 cellar: :any_skip_relocation, ventura:        "616e76117533e7126476e23c754603b19cc95a98ed7ac8a975500a50e7fb55a0"
    sha256 cellar: :any_skip_relocation, monterey:       "a6e2767b812fa49be5b16fca91603591421f2861936ac46d66ad84c08683c6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaab18813f6e4c2baf80cc08787149d60e64eca0e7f202d546759b09d3183be3"
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
