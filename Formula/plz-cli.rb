class PlzCli < Formula
  desc "Copilot for your terminal"
  homepage "https://github.com/m1guelpf/plz-cli"
  url "https://github.com/m1guelpf/plz-cli/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "26fd34c423dafe48acd865d9044f29dd3d473e67945b2fb5bc09d80dbc7fa887"
  license "MIT"
  head "https://github.com/m1guelpf/plz-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52f9b33a7c71716c449f149917edded90c289e4b4b3a686915e7a2d215209608"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65a068de71817e7420350a8ad4cc6e8b80e9a4082b9356f4acbf6372037055c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "864faf853dc0a8296d7713a49ecd346aa9b5c2b8609ae83bc1b8eef935239c8d"
    sha256 cellar: :any_skip_relocation, ventura:        "ec81d160a3e163bd8b438719061a3540743c79aca1580947c84efd224a234cea"
    sha256 cellar: :any_skip_relocation, monterey:       "5162ed279aa33bb15a122d632b87b73c4ee4f3b383f6b2cb5bad69db4da2d787"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ccfd187e4f9ef17b489e4d3ad7d93239d76dd19e4268a858d63c88e8b88b0fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843e67cdcad7210a37f73ea3c4e0f42ac536b1d26eb232b159eeae7e55e39ba0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-XXXXXXXX"
    expected = "Incorrect API key provided: sk-XXXXXXXX"
    assert_match expected, shell_output("#{bin}/plz brewtest", 1)
  end
end
