class JqLsp < Formula
  desc "Jq language server"
  homepage "https://github.com/wader/jq-lsp"
  url "https://github.com/wader/jq-lsp/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "1cdfead7b79fc732f57003e43cf1abf013ce8c7ba4cfacefd7e2667748bf07e3"
  license "MIT"
  head "https://github.com/wader/jq-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe2d0416f509cbf40f2023581b4d0b4835b1a33206889243a6589908297a975d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe2d0416f509cbf40f2023581b4d0b4835b1a33206889243a6589908297a975d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe2d0416f509cbf40f2023581b4d0b4835b1a33206889243a6589908297a975d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e20cf52e80e4c80c2e9e66a7b25308ca3875832b091b78a6c98d99f20febd915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a628404c82373d66469a3fcbccfadd2f9df400045c35b6caffb9e1d6465719b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbc48c5f1420199db1201e3bdd7124605d0edbeae5ea1802089c5943fdd73dcb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jq-lsp --version")

    expected = JSON.parse(<<~JSON)
      {
        "name": "jq-lsp",
        "version": "#{version}"
      }
    JSON
    query = ".config | {name: .name, version: .version}"

    assert_equal expected, JSON.parse(shell_output("#{bin}/jq-lsp --query '#{query}'"))
  end
end
