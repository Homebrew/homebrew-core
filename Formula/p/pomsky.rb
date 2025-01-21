class Pomsky < Formula
  desc "Regular expression language"
  homepage "https://pomsky-lang.org/"
  url "https://github.com/pomsky-lang/pomsky/archive/refs/tags/v0.11.tar.gz"
  sha256 "602cf73d7f7343b8c59ae82973635f5f62f26e2fe341fa990fca5fe504736384"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pomsky-lang/pomsky.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e2c2f94091ab38f06f95ddca0c90df7cb9c7f4fb16e78518b365756f68d04d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f191a0eb866fe3c9a43e6af5ffc963c5a08ba72ea49dd93eabf5ced8c960081"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41595db77e38123a28d0976497c6ac257214fed22254755e54b89cb5dee7d127"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7072d58cef2e775feb2cfd3c2f9da2e8b8f5ae656ff530b8bc3c8aaffd048fc"
    sha256 cellar: :any_skip_relocation, ventura:       "6079d8a1dfc89585ad17b5adeb197c38f995fb0db087fd341d0aa1320f090eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b045ede5c8563463d1afc5058db6721ea82017350d4faa86394502fb756d286"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pomsky-bin")

    bash_completion.install "completions/pomsky.bash" => "pomsky"
    fish_completion.install "completions/pomsky.fish"
    zsh_completion.install "completions/pomsky.zsh" => "_pomsky"
  end

  test do
    assert_match "Backslash escapes are not supported",
      shell_output("#{bin}/pomsky \"'Hello world'* \\X+\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/pomsky --version")
  end
end
