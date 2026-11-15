class Mado < Formula
  desc "Fast Markdown linter written in Rust"
  homepage "https://github.com/akiomik/mado"
  url "https://github.com/akiomik/mado/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "55e3c611a5096f7085e9d439c4ba91b8a8d749de6cd313ba09771d84f484607a"
  license "Apache-2.0"
  head "https://github.com/akiomik/mado.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43d3e42cc1f5c331a18ef310c62ff243d2cea6c93e4bdedd52d8731bcb6ff9e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4ab0157e03de32712356af74ed9e451c36f9621c60ee6f070ff1e31221c5fe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3183576fde63bb42114e780b77cf4ae8fd1e7b509ca02e1c1cc3ac10cf8d0e2"
    sha256 cellar: :any,                 arm64_linux:       "53dd3bf9c81fa304291d03febe3c78af3cc163771b7bfb45c0c19787445975c5"
    sha256 cellar: :any,                 x86_64_linux:      "ec2df4bebd2130e730da224fbcfdafde3a481663383edaedee56f5a6d043f342"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mado --version")

    (testpath/"bad.md").write <<~MARKDOWN
      # Heading 1
      body without blank line
    MARKDOWN
    refute_empty shell_output("#{bin}/mado check #{testpath}/bad.md 2>&1", 1)

    (testpath/"good.md").write <<~MARKDOWN
      # Heading 1

      body with blank line
    MARKDOWN
    assert_match "All checks passed!", shell_output("#{bin}/mado check #{testpath}/good.md")
  end
end
