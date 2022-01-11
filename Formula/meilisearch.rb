class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.25.0.tar.gz"
  sha256 "7c7e2caae99c7ec504eb25186c2a67832bc1cdf4572102b85807b9540709a7f8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bda44bb3624f70ad5028b9c2c4c8c0e2e234e23203f9560ffb54516a7ab4ca4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ff63030e0002c68d46e0d4338a0fdafe4abd3f0678211854accd4c608eb76df"
    sha256 cellar: :any_skip_relocation, monterey:       "f5e041424211b26948eaa482717287f4b698858e0e9f3440f9bd9c591949856b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2b3854d72d1c4b80555c652ea31a7bd66ea59adb0051a3bf04ce0fe473af66f"
    sha256 cellar: :any_skip_relocation, catalina:       "ae35aea30e946852fa1f3c09dddcf8ff94658d37fc85d61b7465a9ceef9d1e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e45dc54e12985166082be01aad04effb77b3dd518b3801389d35424afd8f778"
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
