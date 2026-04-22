class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.42.1.tar.gz"
  sha256 "96e49210abcb4f626ecded304fd2ef22e6f76c89862047ee4273650d49cd7be3"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4f3f5a04696e7016175a8a549c39b6e2c3219f1cfead686539de6345053803f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "522e0d2b0a55986f6f14eb319e72fefa5ef22804a4b4fed57ce2a81708afaa99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cf9d8005d16b0f9030d005931b280d102e95b657da74eb40cb50e0bdb0800d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d8218137a0dc0c554f1ff6fbe539052299c6c8581f1dd15f7a802bbe9f04284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26a854c8ffdc009e6cad9133c1eb0f93ee19c2a27ec9e6d7cffb17b17121de46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7be7c3bf537c04f1ba01eaee0eda3dfa59ac70918c42f8c8f8cae08eb30f271"
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
