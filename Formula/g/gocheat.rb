class Gocheat < Formula
  desc "TUI Cheatsheet for keybindings, hotkeys and more"
  homepage "https://github.com/Achno/gocheat"
  url "https://github.com/Achno/gocheat/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "338e7123411c4a5fb9fe387f7155f1e48d511845fe7f2383718d16abf54b26fc"
  license "MIT"
  head "https://github.com/Achno/gocheat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae08f0650712309af012501f33769c1687deaaaaec02f3a0bedb58a0136a460e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae08f0650712309af012501f33769c1687deaaaaec02f3a0bedb58a0136a460e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae08f0650712309af012501f33769c1687deaaaaec02f3a0bedb58a0136a460e"
    sha256 cellar: :any_skip_relocation, sonoma:        "955708f2189090ecf8a3c9eb4186761ab97dcb6469db93a2f398ab00d9575f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76cbed7ecfcf140e7265c160bf91e37b15d79beae99a9ba2964614e73b1ba173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62a71a0b01f80ddadd42cf1888bb9c086ce849727f2e01982ee19309748744f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # failed with Linux CI, `open /dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"gocheat", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Description : keybinding", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
