class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "1455b2ecd42f5da64e1d679d248599f09805c8c3f84fb2cb41aa76d638d4c462"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc38d54aa6e1fc97369a3f8a4e79f2b014297917803d1fbf1fa836eac27b09c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a64b2c62c0a54aabc567c4bc93b6d4a31ac6232e01153a04f88daf7d1b35665e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c26d16f014c01049cbe33f192da8e23b9b3493a2726a5612c190e8eb67822ebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "757d15265962a1adbd5894af34646ade55cc7ce4732e89ecfaf394781b57da1b"
    sha256 cellar: :any_skip_relocation, ventura:       "da5b11333322b2771528702f21a47c14b2bba3737ea750f43c1da0680494a424"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eddcf213a805c906f378cf930a82e9ffc957cac3313588d420164e15d780cfd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79681f45659a7100bc1aa4ef7af669e61b0c89450d10c2e931374ced734245e2"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash" => "cyme"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end
