class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "2bc3f97cb5e57760f757865da387bcf03f6e0826ce9e0bdff85b7455d9ec1f6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fc7da52a20e88d8f0d801cb41ffb11d2d1e9df2c3b5e2f3c5c86c9007ee558d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0424064953e9b17aa54c2242417433af9df7042ed00c20eaee74534d5836a120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da4aaedcc020b2393c6bf421741c0117b2c9c6e1f062387933caf4fe8ee8605"
    sha256 cellar: :any_skip_relocation, sonoma:        "af561b41c91c0b7b580709a8c8cd589c964fe92ba69603b9e09bb434cacfabd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5c987e33b80aa70f9d269d698bdce60a740d5efb9fee07c0d60b149b96fe448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de37c4112c107a00bc27ab84a7c6fc5a7b5967d0734a7505465fa1a2e4523eba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end
