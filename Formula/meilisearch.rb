class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.30.2.tar.gz"
  sha256 "f6cfdc3f5445f458fe77b3d5864f55d8a127f86ace0bffa5e094fcb0f28adb18"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38f926665aae4a4892d652901f9db239f5fed1e3f162c0a08a4f7a8f9ccef9b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a3885ec00debb336deae84a145e7dfa71741629cd2f888f4e8db0e80bb4a89a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70173e7096c8332c83b5e058fa69f0476887d1d5008d3a293d32d0703045aaac"
    sha256 cellar: :any_skip_relocation, ventura:        "d2b3f106fcbf3760d92900f03783716f105793b2131f65f574254e5cade61ab2"
    sha256 cellar: :any_skip_relocation, monterey:       "fc48b90859d9ab8890938f3394c5118892f6625528f595a85e921503d1590a4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "24121e88a19d761468dded25659bd34ae423a53f6ce3b41c46fa6f2de1352365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c8091e1ea3459419c21bf74960212fea2e1c3aa34c7faa45720b9bd1c964752"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch-http" do
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
    sleep(3)
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
