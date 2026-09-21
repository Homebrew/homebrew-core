class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.28.0.tar.gz"
  sha256 "63b362d454aa37496c6d5eaebaee890b47b19809e3b0fb9f60efbbc97a713160"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36a764782d1bca7cfdcaa40a0a57e61d16aaef09857087ac99a6c1d9980c22c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05926e1921008838a4fb3477bd8fbaf3322f1775b691d111aef7f053ca39831d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9947581e9545f365925a615496e7b22faef68b02ecb0730f72146ba6bf4afee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9af25cfa5123077b7f1952b570465360e472bda58fd8fb38c7595d81d6c435d6"
    sha256 cellar: :any_skip_relocation, sonoma:            "6760ec0dfdb02a651386b0b485118fad05f1a7ba4b9c402f03975bcaf4935d6e"
    sha256 cellar: :any,                 arm64_linux:       "67b8bf78bb617665ec7bec6d46ee57336242f96620f582474ccaec0c6a98aa54"
    sha256 cellar: :any,                 x86_64_linux:      "9c1264450a445c9de72f1e7185477753977a6131c1e969066279476d60d0f36a"
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
