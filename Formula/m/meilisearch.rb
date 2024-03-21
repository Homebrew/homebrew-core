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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84a9d4a46b62b588cc142eb8f0642aa0213bc1c5476e8558d92255753e0c6a09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "107d6f6319002b1a55ded917b39b86d491e7ab7e0ceed12dec7451caf522c14e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8782bf4c56b3314663e7b44ec61006f56cd8f5b05b11e6119dee98e1f7c399b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d539b4bed0ea3d402cb977187be6ff28e7aa042461048762793eb7caccda971"
    sha256 cellar: :any_skip_relocation, ventura:        "c699b71b28506113d4b6c4b499233994e942e8f5c9e667ba6404994e52d882e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3193b008c2a613dd3d02e0672c13654a2e0d332d09577c157a0f1deb07ffcda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64be36127aa3bad678f5a2cbcb646e50cd24fdb15f1f0b958bc7898b19d5253"
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
