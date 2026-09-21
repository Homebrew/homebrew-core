class Funzzy < Formula
  desc "Lightweight file watcher"
  homepage "https://github.com/cristianoliveira/funzzy"
  url "https://github.com/cristianoliveira/funzzy/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "79c4e934ea2035b365b01d5bcb1c7b72e6cc089543fae29c71800ae274638c0a"
  license "MIT"
  head "https://github.com/cristianoliveira/funzzy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8f5a15455315131175baad0bab4cde9737f089f8ca6036462353f18da5cef06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1bdde97d95332903840a025af4c36348f78f0e24425c1908672f15a357742f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27125dc7ca5c102c8a4bd519e5aa56836dbaf5073b23bdda905e09bc943bc7b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b7da2d38750d2ff7ac2cfd2303cbb47d056d27d610c97b8be6aa20babf1f524f"
    sha256 cellar: :any,                 arm64_linux:       "b23022b4706528659d66ab1b3b60dbed24a3b87858795c8343b4e46b5dbc4ad1"
    sha256 cellar: :any,                 x86_64_linux:      "4369d53c7ae9ac195a8d009e05624cdc12eb3c610a11910752f52784ac2a5e42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"funzzy", "init"
    assert_match "## Funzzy events file", File.read(testpath/".watch.yaml")

    assert_match version.to_s, shell_output("#{bin}/funzzy --version")
  end
end
