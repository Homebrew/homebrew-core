class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "3706e7c986cb5641ddd20e66d743ae8d978c7b8fd37075644a07e592fb991746"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b635e3319e966a8c6beb65313ab1246871ac6e88da33679e61a90cc97231a596"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa4b542a823aeb5a162447dc435099ee2b22a8ae0e81863ab546d5d50ee0b0c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3b98ab02fc66e741cf2cba35b66767ab1cf4e6bae1ec23efca311f2975e4207"
    sha256 cellar: :any,                 arm64_linux:       "594a9ca2f45cb19830f78b8861b44c967c54df0553db380740c5f67a8fd427f6"
    sha256 cellar: :any,                 x86_64_linux:      "c297c5b0c814349d80856a68c93fb09e212a16db41fd5c50b69a9c7b6d2ed3e7"
  end

  depends_on "rust" => :build

  # `test do` block connects to example.com.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end
