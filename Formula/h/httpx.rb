class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "b29319c085537047bff8acf72c6cd4ecf17585ede97f4afdde2304431c74e64e"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5773193f7ccc8e16c627067b10a831461e61627ce6ad3b9ce82f387f8c86eca2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b39dabe34bac875476fb8d557b39f2fa6f8411e045159068296a7b541626ac5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "deb0167e0b09cc17ee1fc2a443fd30b2b980157a2e7c52538826f74e1b6ad54f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5fd8224c5033a1290e4eba34b0ca98ff6ad02c6dd80908a18579ba70c30efb64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14e5f188dad360ce8ec3335fe9a545edac0257181496d43793b79894f4b72414"
    sha256 cellar: :any,                 x86_64_linux:      "646bb27ab03ed619244d8430e9fdc8587d4f419b65486becccf18151ac7a6471"
  end

  depends_on "go" => :build

  # `test do` block probes example.org
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
