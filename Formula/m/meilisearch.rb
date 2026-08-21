class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.53.1.tar.gz"
  sha256 "b1041d18f18f70b0069689fe46cebfe1d34fe80f48db1177a79a9ca89db5ccdc"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fe0eec48314ff4382c0d9047f08800316667c3189a101140ff392ecfd5eefa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c1364596162dd2811c6add0d69133461f96a6571d8735157d93dfe3e0372d4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60820cc873b1538fd30fbfe9e553a89b16e1ce45e9c50f518d8bbaac4234def8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d77b2d8c715567c678b6fa94039233c9885bcca239996da39767cf278d1baeb5"
    sha256 cellar: :any,                 arm64_linux:   "937b0ce58dbb49a74d6846381f9927fb4bea90d3ffa307da490b7fb19570b401"
    sha256 cellar: :any,                 x86_64_linux:  "f1da77a5131988526f2e217ae6899cb04d35cb045dd11134e55117664d2b2f74"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
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
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
