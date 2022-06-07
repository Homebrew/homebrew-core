class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/v0.27.2.tar.gz"
  sha256 "d2e912778e6865fd98d59258a07573dcd15515373f057f4e7a967217f5dd61ec"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53226b817103e85d5794502b8eac21660b5811945facfd891652b40603ebff43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1de9b9487dce35a9b45b236b87c62301896af448c7ffbed5de27959514f9f994"
    sha256 cellar: :any_skip_relocation, monterey:       "be3de6af73cad38fe4a21415e6980aebc4dc3f87fb045c744d1129261fbf3291"
    sha256 cellar: :any_skip_relocation, big_sur:        "470c61322b5f1ffb888895ec767b54a40a7a41d283bd698b68d86b68394ca078"
    sha256 cellar: :any_skip_relocation, catalina:       "e9d86a93d4e442fe9ea22773eac2b5b196705f392ea8d93c001fbc6d57ca11a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aff8b27a6731f1c06b31b6bda4f07c4c131d624eefb2a20750e604344782120d"
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
