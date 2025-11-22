class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "70c21f379b0a3264cca153b8f971fe45588a574333b71191d195ace7729c29cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "055c48d60b5ebbb6ba5d8133281863f05a8524c9e5083d27cd57ab3e87b25db7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca03de278a66fb6dc1bb3b86bd55bb9db9f7cd52323337c441c4613fbb63883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8990899cc3a896a9b70ea30f40e4cd94fb74b3a9e28d7c7c5fbd3bbdf0e12d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "620b60c87181a2c5edb6148b6168c65b26e233217d0e0d1e1bcce0b5941f78a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "007d25a1b32675374a233d89e080184b0c92bbeb4f7431a97912b9d8646badf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5586879f825b40f743dbfe2e52e48e5f63e84c2738d6a842931d28e8d242ed7"
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
