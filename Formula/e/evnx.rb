class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "7cabb4c51997ace31f9b39c4eba24e8cc7c34801e7d98f41097f88b6ba864d17"
  license "MIT"

  bottle do
    manifest_sha256 "2bd0d6c680933a070cd7a92ed899be180142e75b5c0121500164837f35c1b6a5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "060825be39b33a9fc335a696431e8a957ad148cd4736c8e04b04b415ed707c9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b24024a041c801bffc35f0e51e29f08dc975f1bce05685c501260163b3f558a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74f33c0b72f9dd2aa918cdf47ee4597e467b2dafc6de89c629836ac92c46e528"
    sha256 cellar: :any,                 arm64_linux:       "d323a41826037b6afcad21fa8b427ba43cd6da2082057e499a8c6901be1b5813"
    sha256 cellar: :any,                 x86_64_linux:      "53ebbaca3c4b99b667738e9cdcebef521d57c14f2d6dbe1e4df2e81a5adaaeb4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
