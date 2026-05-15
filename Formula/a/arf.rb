class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "54859e9d9517b2df1f0149bf9a0ac91e8d4874a1854b79f252c99a8bfce68392"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a15fba3387786e4a7d87dbe8cfe31860a8eeb641ecc7ec0012deed60b653b93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "051a21d019daa07270eddacaae22fbabfac8063d7f72b91c3527b42f328ff492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f8699532beafd415dce27a2de51d67a8674ff130caf8f866e46ed2211db2e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "9adf76ecb628ae3041c57e1f7a5698ec1048554036adb337cc94467e12242364"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f12ab74afe961f67df8a9c344e0ab7e8eb898de03b83b6a77a2bd7dec7423755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59e751f184c681e84b54459489eb5467f092227aa6132eb990df054e1a4e921c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/arf-console")

    generate_completions_from_executable(bin/"arf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arf --version")

    system bin/"arf", "config", "init"
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/arf/arf.toml"
    else
      assert_path_exists testpath/".config/arf/arf.toml"
    end
    system bin/"arf", "config", "check"

    assert_match "history", shell_output("#{bin}/arf history schema")
    assert_match "sessions", shell_output("#{bin}/arf ipc list")
  end
end
