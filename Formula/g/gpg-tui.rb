class GpgTui < Formula
  desc "Manage your GnuPG keys with ease!"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "741def01fe84ee20c3eac1cbbe2533e1a9c387832cab31b5d233062338254ce1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab9421f69bd3e3465ec5cb65f87546c9be73c60a00e5c37270a0002a37613ab7"
    sha256 cellar: :any,                 arm64_ventura:  "c03a2c158b662d2d9768228a5f97f254df958800ddc84fe0c054c24ad3bc513e"
    sha256 cellar: :any,                 arm64_monterey: "ccffe6ab3a46d71ac8d5c6e9034f66116ef86ddb2276eaa0a59f5365c3a1beb5"
    sha256 cellar: :any,                 arm64_big_sur:  "9d60fd0875f85f67665eba2d2faf5e30580d30ea06e1f8695d28b6791139f1b0"
    sha256 cellar: :any,                 sonoma:         "279176f05e9e62b09fa6b246f74a861298d42f4fdf61c01ec5ccc657ce8b8f29"
    sha256 cellar: :any,                 ventura:        "2cc05f7d7aa2c3e2a70690ed1a20625703c0dc21ea14d7b749623503823c0eca"
    sha256 cellar: :any,                 monterey:       "b322b66b2601a8b9ed4a5535cdda09f8e8a20f061259cdfc274b1b9e68b5e527"
    sha256 cellar: :any,                 big_sur:        "96d36468b9a5f0c6cb608b201873e79a81534234627fe903f1916e18200d4e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "050be7f81cd6acc614fe80d704910eafa558b1d1bdf89028163fd5a0ef213ae1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"gpg-tui-completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm_f bin/"gpg-tui-completions"
    rm_f Dir[prefix/".crates*"]
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    begin
      r, w, pid = PTY.spawn "#{bin}/gpg-tui"
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
