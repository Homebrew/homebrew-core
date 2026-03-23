class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "443a4b07d191c9a9ebcaf89e360bb2ad382bfdec1c520e2fbfa3492eac8a4e06"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f63ea0f7914c4ab208970f17cfdb6c246b6b8cefff3e1a0600c190eeba1e3a5"
    sha256 cellar: :any,                 arm64_sequoia: "32b01e642fd3ab4dbe8caca73a0cd5fbb84db226a6ab9ae2612e49c3fe3f3978"
    sha256 cellar: :any,                 arm64_sonoma:  "f5290fff7344aadcd6df050162585c0c58635531cce273ca9de3e1632981103c"
    sha256 cellar: :any,                 sonoma:        "54c344f28d451873dce18aa74f78374d772b7c4cb569035ff3e90be198bfdbcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f55baa328b363c2b56dc55651c1ebeb925c2f8b9adb2312db9c59c288997c781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f714d7c8819483b88f93c5d135c18cce4994d4534d2c364b001d80ecc8b50896"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end
