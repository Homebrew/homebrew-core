class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "5df6636ddc18072c4747ad54814edb9e2535730e0bd068cbaef82c7f473ce929"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1c24caa5abd764c849ae6692ffeb6ebb35bdf8ec2d36fca9b49a1f862b709a97"
    sha256 cellar: :any, big_sur:       "56f7f6cf5b1e3b7610c0d0711c0de4ffd7602232718f4f459e68acc79fe32173"
    sha256 cellar: :any, catalina:      "925bb9578763705166e126241f654714a4ae2024cea637a81d63a7dd30cf34f5"
    sha256 cellar: :any, mojave:        "d8c4469e691e4cd1043d4369c1169931d024783da66b1ef5c056343d7d7a29a7"
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
