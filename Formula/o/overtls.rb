class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.41.tar.gz"
  sha256 "6b739caceaf2bea255bdd106fd1590eb04df7decb3328ff6d0d83fa02c2f8be2"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6174e0a01b98cccf8a1bb6e4b27b858d88d6c9db62e508dc142cceae773278c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1499c8c29261e38f6e78aa241e97091506b71465e69778bf5c682725c96030c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "caabb69876cc47e122d2b8f7d9672314cc875baf1868a056a7e1baca0fd7b93a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f89011c8d92fb90d070452012a7d1e03d183a4e6959ddb98cfc5e23502bcabda"
    sha256 cellar: :any_skip_relocation, ventura:       "2f39a6b872cd7d2a7838d676be90a17209f912ae4b1177845ee184bde72236e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7026b4acb6b0f90c2d3bce30f0773dbedfeca580601ca5b181c5bd08122c0dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07fc0f01d81c7adef78795539391869af6f711dc3d37c9e585c96b8801c436d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output(bin/"overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
