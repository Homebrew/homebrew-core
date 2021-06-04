class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "bb5b63cfbbd54d0b140f7e577a60d1402a7da3c6c4436b76bbaf69163844c078"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d7e62f3e5c5c574ddd1f24faaddb11b9f30629462f53ff58ff63b412d28ff174"
    sha256 cellar: :any, big_sur:       "114f34d7b5f0c8bdd9340fef52878532d5e979cc12a9a2b01b80e2350b9862d6"
    sha256 cellar: :any, catalina:      "8a64444ec2cfdd203f81f4ed4aa5f1ef18bbc056eaf27e263088a8641e91b4f9"
    sha256 cellar: :any, mojave:        "eca92bd17197ecd2c7725ab5227a0cb627d95a0cfd34a6680c36e667502dd670"
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
