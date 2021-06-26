class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6de558a717bbdad5bea55488b7c322756879bd0c6c27114a775108bfffe133cd"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6a4c4c9fb4125449ccc37b1640d7a2987d1b21e22d49f43496db43882ced46b7"
    sha256 cellar: :any, big_sur:       "8bcbc67d0889cb1b778b02aa9268ad2e220aad16ca47ce56519749962f8bf9a0"
    sha256 cellar: :any, catalina:      "549a71c5fe0b4db2e446f60863d8734545b73cef69de6a5547c3ce0eefe0c505"
    sha256 cellar: :any, mojave:        "3a5fccd181ffc6baef35c77679f95410a493767be351014accc7eba3a68e0007"
  end

  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm_f bin/"completions"
    rm_f Dir[prefix/".crates*"]
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    r, w, pid = PTY.spawn "#{bin}/gpg-tui"
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
  ensure
    Process.kill("TERM", pid)
  end
end
