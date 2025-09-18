class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, yarn, just & task"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "a3058ef86749f2fb89d5c0414d24f5b6307802966d6fbb1fd5e9c72ca7a74c18"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "540a10dbfd1eba171dca9684fc9faf0319a5ca8f45928a36e52e0377c052b2ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "078bf964b0798c8a2a3f69139ca3042e3f508b3de2dbf9551c1784f83a359efa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a923b0f3a2df5e73ad518ca18af19a482c0d517c4e93f4113afadd8009e7e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "95865dfed88e08dbabce171cbb5d8425e2f1b73139f789a1745dc5c5ded38c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94fe92062045c35353030c026b994d87cc6470306d00c5f8b100a60ef9402dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5ead0861b1b1c0557de40df847da2ee155dc47411e8aa5674b44a7d5ba4ab0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
