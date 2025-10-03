class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "bf5209a9f5d6c50e5f4000cab3e9042a7fd25ffe03d97a3ee3028c701625b611"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c012b5177f306c96b5741fb2c3030a489da42b8fb2ffe79e9a678d54889c4bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a31271f9b2e972398f9d005711dbe461db8152ae5c117305254fdf7c0b5fb66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e484c65d93ed4c914f78eb17aaa7c872b97c943fe6a4c3e1f25c7569a1041836"
    sha256 cellar: :any_skip_relocation, sonoma:        "679a1f10682673cdaca4634b34962d09505e7aedc136d998efee9bde5a64da95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b6200fec4ff4b0410ffc6b022064659db4cc3c6cc1fc881cd8fb6c06e381c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207b04f7e16744ca4ead2f71d146f72634d9653db18cb66f11faa805cc6ef28d"
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
