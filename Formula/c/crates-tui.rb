class CratesTui < Formula
  desc "TUI for exploring crates.io using Ratatui"
  homepage "https://github.com/ratatui/crates-tui"
  url "https://github.com/ratatui/crates-tui/archive/refs/tags/v0.1.25.tar.gz"
  sha256 "b02e2fa3b7225b5638f9ab8716c3cf21dfb32d96aee140ead2f451005abd58c2"
  license "MIT"
  head "https://github.com/ratatui/crates-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4d3f4d546495d9eada59e3329b86c0172422e4796be32ca05c01eb3303e6f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f56fcc14fa7ac18c23012b124c2c1332b496ca0e9ade5a07a6d531a5f7bb4e62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f81c73519341098deba38f9709c99347db6b33612bba1550711e68a45a0501"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bb365cdc581270ec3b678e116906be8804b8456f9177a9da96c82596c5c4d8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a9d22f1366b378bcc6815bcfaaf8757f7411e2ebcbadd8d25fdcaaee58e2162"
    sha256 cellar: :any_skip_relocation, ventura:       "b2a38ed0df2652636b17333925225751941160871dd6a2f33a41e3d178a92271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d2f55e2a85701ef682ebd95b1e545419d31ce1342eb665b044441309e0f1d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61432d14ad58729837802eb342892a52a6fda9c600efdea3e25f6f3f4f570d7"
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
