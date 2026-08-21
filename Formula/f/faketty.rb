class Faketty < Formula
  desc "Wrapper to exec a command in a pty, even if redirecting the output"
  homepage "https://github.com/dtolnay/faketty"
  url "https://github.com/dtolnay/faketty/archive/refs/tags/1.0.20.tar.gz"
  sha256 "40a4d1cfa3f265f94895cb1430e9100df43ba0b04c551349cac2973e033a7775"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/faketty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a86caecd28c8fad74d1454ea7843974a03fc16341564bef4320aad1d865693c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f36ccefed5e98d700837c7d72add3b35ebd96118730875c5e919441758eb9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bbb88d91f41f836daf40ab26ae264fb4fec30371c40a0a094be0748af26185c"
    sha256 cellar: :any_skip_relocation, sonoma:        "65f0f924b5db899f619d126b38ee38cd47aa1e04b425fdac44b5a3b41caf535a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c1416b7cdfb26821b8602c1a71cc5cd0e2ca31966d2cb4255832b578fb3d598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ad352b95eb94a89baf8441410dcecbad6c33fbe4b77e8d55253f3c662e0307"
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
