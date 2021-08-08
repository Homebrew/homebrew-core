class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "12c61fac67f6f9b90c9f92e5ae754652b024ea3f85b99a2ac359f44356c49467"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8e67bb8819716a1ef228d8f7c3097f5b52f0330e6cc233113ce019faafa0a3c0"
    sha256 cellar: :any, big_sur:       "cbb66584d7f2aadaba94111ff6a31bf982fbe05c9631689c52501aba75e24235"
    sha256 cellar: :any, catalina:      "adfc7a1dc3399a4ab38016c39fd613bba2f4de33cdd018361b4fff9168a6e589"
    sha256 cellar: :any, mojave:        "14018c3ffb4535f2034d648ddd0aaf3f4a1c2aa12ab314bb99602d1638ebcc1d"
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
