class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.30.0.tar.gz"
  sha256 "7d65c63ffeaa89f546e4eb99a3076cecaad2faaf3db4477d8b6139cf6d14be66"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27d835c526a57dbe28df9108c5c5e314ac13e3285fe3390b8bcbcf8a421d2214"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "132948429e430d6fae5e880f4ba2d4afbe70c8148533dd2dd76a2b16681963e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7665b6e9df5072e43fad3af0fd978ca7ba91bd54126c6d58c25fff04535f61f3"
    sha256 cellar: :any_skip_relocation, monterey:       "0023717cbb27fe0048911f3d0af88d7058020f234bf90705f113182143c1de68"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e389da8dbdfd6158068b3c0d8020b8d08eef3f3e1473aa1fa97dc27fca12f18"
    sha256 cellar: :any_skip_relocation, catalina:       "4c5a6e20d880c14061c4914a5f42773f858eb28e496cdfe007ae3411df866031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2ca76dca6da84c3cedf8a285bc9198f7977bc66d73d80c9f716910875f666e3"
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
