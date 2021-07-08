class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "49c04725d6747ffdf1cb84ce733213869ccc3bd36aa2752aa9af0c5c04addc34"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c0ab662ad75180b91feeee4e52b895a1b145b77088eb951f8fb26db488780020"
    sha256 cellar: :any, big_sur:       "b8f0f05b235c00df690f57aaed9a13aacbba5df5151f5b662dcf005eb712ff43"
    sha256 cellar: :any, catalina:      "00b51e2af8862d533f78bad0e433886bde64beee2d69d96981ae2b2440cf93e7"
    sha256 cellar: :any, mojave:        "f456fde7c7993752b341f3c38d64a7c17f9ac2a8ad780516c1d588f500409a8c"
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
