class MagicCli < Formula
  desc "Command-line utility to make you a magician in the terminal"
  homepage "https://github.com/guywaldman/magic-cli"
  url "https://github.com/guywaldman/magic-cli/releases/download/0.0.5/source.tar.gz"
  sha256 "a72142b90c892f5b0301e7f4c4f5a901dcaded73a5a98b001de45954c92522a2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/magic-cli", "--version"
  end
end
