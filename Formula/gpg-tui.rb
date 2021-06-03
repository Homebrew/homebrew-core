class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "bb5b63cfbbd54d0b140f7e577a60d1402a7da3c6c4436b76bbaf69163844c078"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a9775e6c21edac62cc8bbdcfec8f858ee0694fa17dc7ccad47c6d636f1414221"
    sha256 cellar: :any, big_sur:       "e15ed192dc093a8eaf2aa76459e729e8901a9ccecaf957b53eb41a4a88aa668e"
    sha256 cellar: :any, catalina:      "6c05eaf37cbbc14b204642cb69de853772ad14fadb9fcc1789dabd4e283c46c6"
    sha256 cellar: :any, mojave:        "dfc772db8af73ce6208f3af0a9da3c0f2d4799d2c771f0ff2bb670b2d0a2063c"
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
