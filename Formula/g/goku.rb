class Goku < Formula
  desc "HTTP load testing tool"
  homepage "https://github.com/jcaromiq/goku"
  url "https://github.com/jcaromiq/goku/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "95635c42cf748b64a4d1a04b5460397331366a78ddd890f7e13bf0e811c27976"
  license "MIT"
  head "https://github.com/jcaromiq/goku.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c00f79db8bb7983c31fc349b3ecf9ae7d56d82c03aa38180fc52d2571ed787a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c4cea235901e79e89c646070ddacf7966b187020bfe47e758c1aa3a4496c1cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc2dacd815a5ac3c0e4693dcbcd274671b3db08e86ff78ded17cdeb2193a507f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4427222fe868f906faac00c73e4674f8724d669c9395e1a00ca2ec6ca2b1003"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6169386eec892db496aee97bea00fc35e9b52491b72e833b7f56d84727ed4aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49853c2c61b0f86865bec8109d5a7cca52bcd1a48e2574155287ae226a6e958"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    output = shell_output("#{bin}/goku --target https://httpbin.org/get")
    assert_match "kamehameha to https://httpbin.org/get with 1 concurrent clients and 1 total iterations", output

    assert_match version.to_s, shell_output("#{bin}/goku --version")
  end
end
