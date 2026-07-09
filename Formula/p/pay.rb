class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.21.0.tar.gz"
  sha256 "97b70d9e66a0e78cdb564624baeac0f0fd47dcc7c8261415f01dbfc42b097a36"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5bdb43badb9e73f782e4e230272b61c212b7030ecd483617e380354e7aafdf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eaf1dbc6eab35e60ea31b692f1fed36eb2e401f4ec7643c30fc9fe66d4ee62a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75e3409ac58232de10640e19eb1af891f1bef963ee242a17a083f75ac1596d7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0acac8cc8bacfe28ffee290d0c3b104b3101285453eff81c5518a713ddfed31"
    sha256 cellar: :any,                 arm64_linux:   "fd2fd7632f95400d1dd21306ac38feea3a80f0a8d6849056309181a09eeadfc8"
    sha256 cellar: :any,                 x86_64_linux:  "7d60f7bd03964488584e9aae66ebf63a923952ccbef6d3bfa6bb51fa7f5dfee8"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "python"

  def install
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "No pay account configured"
    assert_match expected, shell_output("#{bin}/pay --no-dna fetch https://httpbin.org/status/402 2>&1", 1)
  end
end
