class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.7.4.tar.gz"
  sha256 "6851cd94ac10c76434b2452b2db2817ff7728ddd6b146c07d824c308028af88a"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aac231bd5d5a1da056b33cd0ac2118767081366b0f62a9810b004ecf30e8673"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39ad9e1677c44b260a34a08779b296a56c5b242cb64ecb26622d6e82e21c99b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e735b864292a504f976ec867ecf037739a8fe7b59f29d7b4b5fe8855f7be804"
    sha256 cellar: :any_skip_relocation, sonoma:        "832298cbfb90dee37171b547c7796374b8d9db901b29fa30db10561cb1867360"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d48253ad0f7a93a92ab8c03dc699e28d711f4695f4b08eea4b1ab1c489f2cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257575bcf184989a023cd93723cc1da2e86fb2db5979caaeb853fd438c98c4c1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "no recognized payment protocol"
    assert_match expected, shell_output("#{bin}/pay --output=text fetch https://httpbin.org/status/402 2>&1")
  end
end
