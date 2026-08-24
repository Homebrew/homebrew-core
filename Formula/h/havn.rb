class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "83b1155d5215013c86a3cb808dcc27327e977c5086c8132976e5818b861ea517"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "665d0ca5e09b8704ae179cabfa17ae7ed82de7ca3bf17b3fbe58cb40d21d6d44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a4f1fd2323e54987743dc0e02599255400a1bc711988a9e77c5339a8eac746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d67a1e0c08da706a9ced6747029b49e8afbc15ee3ffdd36490db60b07b7a338"
    sha256 cellar: :any_skip_relocation, sonoma:        "ada6b160a26a8f9b3eb0150818291030d53c963578e82ff035b1fcd216412a89"
    sha256 cellar: :any,                 arm64_linux:   "69d474d49beb21ee28c701c186d07a4a81ad7587b05dc7a0b6558740303c0cf9"
    sha256 cellar: :any,                 x86_64_linux:  "c49d310cf50084c20e13bcf2e98d92d4451d429e54df407bbc09100b53fe2a8f"
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
