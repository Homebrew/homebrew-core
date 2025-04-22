class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://github.com/rochacbruno/marmite/archive/refs/tags/0.2.5.tar.gz"
  sha256 "b1de4525533185b9d0dcd592bb2eb7e9af7cdc863bf110a45720be2534e2e301"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9044fed2abbe05930f74bee4f4f1de20700f8d6f32a1e0d03fe6141f1036c8e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7636b8ca3ec1608843d67c90590ea95c71b4aefbdeba4d163fb40df66d8bc5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88830317a2357d363919fe06b1b4c0804860f257f0a859aa39f1ef622e0840de"
    sha256 cellar: :any_skip_relocation, sonoma:        "bff5c7b07e1e059b78fc491dc3898d8e2c1d2c3d6d76d27e9845c674edab3d15"
    sha256 cellar: :any_skip_relocation, ventura:       "cc0448b1262edc1fe173095d3317c8945dd444d6627b07c81374cd901d279243"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cc57b7a0831ae19203aaccee8ccc5226d277ed76f60939639b727cd8a4a1da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "591b5b32a8a0e8ccf269226dfe0ece3947db93e80f58138a1db37a1836575e88"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmite --version")

    system bin/"marmite", testpath/"site", "--init-site"
    assert_path_exists testpath/"site"
  end
end
