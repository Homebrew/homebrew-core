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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3a12c87aa525b912ff538cd6b1a6aab494cb771428be5a170f13fbcbce773a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c77fb796bd035acdc081e87b4882bdbb2ab08afeff210d037c6b5e5e90f28642"
    sha256 cellar: :any_skip_relocation, monterey:       "179e202e8d543c5dae9297c34c2ab9e7b7621135a419912fd851d4dbcb80cb63"
    sha256 cellar: :any_skip_relocation, big_sur:        "1926405d815883bac802bc93940a1b0774c7e6b9b4f9b806a24563a7465eaa4a"
    sha256 cellar: :any_skip_relocation, catalina:       "01b845057e094b24236951ccce4ddbbbb2cd90ecbd2b75aafb33f8be2fb4de69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b447bc79852eb2a5433ca3572e23818e2404a80458cc91f94ed07ecf9384c4dc"
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
