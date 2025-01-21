class CratesTui < Formula
  desc "TUI for exploring crates.io using Ratatui"
  homepage "https://github.com/ratatui/crates-tui"
  url "https://github.com/ratatui/crates-tui/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "da1a6b5a04ab27c3b26fbd616a9fe8ddf52f437a8259a551b54e4aad4ea8ce19"
  license "MIT"
  head "https://github.com/ratatui/crates-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c52267df6289617bcba63daa6ff840331c6f70f776f7f3e8c34d26751c4b881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "463478088ceefac2044e86795b34725cb357c13f17333d6c476870e550dff0ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32624bf04b0ebf1374b612a18cc1b03c2c0fc1c7f7ed6a20608484c089f52fa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e49c4b4ac31674dcc05d0d43d19a227cdce66f2856b6d034e9464787f146c102"
    sha256 cellar: :any_skip_relocation, ventura:       "d0d66353ac2b2cfe4b7715fad318a3fba3d240c7b091b17c869c42fc06425dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcbdc4adefbce3ff6ea2e8a5edeac454aa9bd19f34d45817f00f101bbf6ffc7f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crates-tui --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"crates-tui", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "New Crates", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
