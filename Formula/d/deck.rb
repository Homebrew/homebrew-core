class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.21.6.tar.gz"
  sha256 "3bef75b2511d670e2b9bf1e862fc1699ccb1d86a40e064321c1d9cca4a9b32e1"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be0c9c52497dfc33f9027af097de5c963330a962a725ca046a4fc17fea6acfa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be0c9c52497dfc33f9027af097de5c963330a962a725ca046a4fc17fea6acfa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be0c9c52497dfc33f9027af097de5c963330a962a725ca046a4fc17fea6acfa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "db30dd298903cf219ba499df9afb3b25540e985bddbd8248ecdeeb64c8bfdaf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f02e666613be605d6904a322de2e9c395001b4699e9f39e95cc326bd753d6981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581c6721da01acf1c7f3ed248f8adba69139c1adf14e0dfbf8b5525289c3b0bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
