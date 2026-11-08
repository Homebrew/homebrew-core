class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "bdefca5d4e4e950dd4123ff914f41f3c89629205c31b342ea8dd85df9c6f6557"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1dc68aa724fb2928252e7b86d14cbe7fee9973d2ab8fb28ff301bcbf3d26611f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c60a52a582edb28cf249b5b8196bcc073436fd52330409a1dfd47037fe840810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bb822a40eeda0885aef470e3006c034bde36eae8c02bdb03b40b2af2d226610"
    sha256 cellar: :any,                 arm64_linux:       "9f5a42a541ad7821bc3379d24f308fdfea374464dfd4a1b71e2f96ec32de50d0"
    sha256 cellar: :any,                 x86_64_linux:      "2c1672ac9c9270d697056c294ba1f6f46c76f01a9e4cbacf3a9527465f1965dd"
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
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
