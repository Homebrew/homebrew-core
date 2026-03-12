class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "63ea4278344e5c975d48fb558c451a8b746af11d18cf15d1d2b3ca6832b25895"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f996e870d269be654ca4eb2380445c14fd6bea983b6bbcb2abe21820c4b5ee2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd2e1697dfb4ac61cd33567e1948a44b840ce71d5c1586b1350513b525f5f7df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45203cdc82ddf0ead55e6a645dd1662248565174fbda915eae83ef8397dd3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "df169db3a700b84da2180860ba419b5872bfe5ab29eef666f259492f4ffce2c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97bc24c1a2d7ad97764470a660e293fb25fce93145f4f8d16853f6cc6b7593c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5bd1ab9351fbfbf69b1201c6ac63cd42dc0975aa9874474be110cd031ca20aa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end
