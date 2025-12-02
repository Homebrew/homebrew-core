class Faketty < Formula
  desc "Wrapper to exec a command in a pty, even if redirecting the output"
  homepage "https://github.com/dtolnay/faketty"
  url "https://github.com/dtolnay/faketty/archive/refs/tags/1.0.19.tar.gz"
  sha256 "9813623a26996153d586fc110752226a7d619242660a61f01b45f964597f5efe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/faketty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbc4f144ba6295f0726fdf57a8b6650441045782f3069b6a67bed179af2baa7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cfbf44d38dd2e7fa816cf039bff744f534114f362f7443ecad8300464678324"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d171c3c068cfb10dd001b2149f8e1b0977f9e22c30055344741b6b5ab5e90e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaf3e17f37f612ed07eb0533d8d206baa2c6b02dd37283ab76a940ecb442b10d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4945595be939159a39a634ce49c1cba2b219ae687bafdf762a7c8fea611f5f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d038ef5f6223e64b01d1d423223158c2b4488a717358ba70806db66fb7c54532"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/faketty --version")

    (testpath/"test.sh").write <<~BASH
      if [[ -t 1 ]]; then
        echo "Hello"
      fi
    BASH
    assert_match "Hello", shell_output("#{bin}/faketty bash test.sh | cat")
  end
end
