class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "8af540ebf7eb0c0ea9f835fb9e76879ea186d4e3f2b6627bb9a7b9a44562da82"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bbc2ae8dd2ea49a87cebf34fdc19fc796c30f6125ac8e15c55fad860c266591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "206eb1cae224b23c368eb2968d5a229153a3a2f62f29edf01b95947e3587a9f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0325bebfe491194647210fffbe9509ff39e5d171c02a145f6cd274e1200b2e98"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad43a0806467a7b642f59e4926dbc6dbd12ac176295687b9f20761f8f9103240"
    sha256 cellar: :any,                 arm64_linux:   "6bbe93bf94f8f3f50105a75b121082daa5b8b4eb99eac18bf76ac60937da6a21"
    sha256 cellar: :any,                 x86_64_linux:  "5084bb184b4492878f839a62a73d7827eb66be3e46a6c51eb9493d2038b66bba"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Drop upstream's x86_64 Linux lld linker pin
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid")
    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid-hook")

    (man1/"pixtuoid.1").write Utils.safe_popen_read(bin/"pixtuoid", "man")
    generate_completions_from_executable(bin/"pixtuoid", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pixtuoid --version")

    system bin/"pixtuoid", "init-pack", testpath/"pack"
    assert_match "OK: pack \"skeleton\"", shell_output("#{bin}/pixtuoid validate-pack #{testpath}/pack")

    require "json"
    connected = JSON.parse(shell_output("#{bin}/pixtuoid connect claude-code --json"))
    assert_equal [{ "id" => "claude-code", "outcome" => "connected" }], connected
    assert_match "pixtuoid-hook", (testpath/".claude/settings.json").read
  end
end
