class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "12c61fac67f6f9b90c9f92e5ae754652b024ea3f85b99a2ac359f44356c49467"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "06efae84d007c155647784aa20a8bb165f9fbe11b44c9c621aad9a2ab46c3395"
    sha256 cellar: :any, big_sur:       "0386a72fd124e670aa2bc38a6878bba85e28264b0655500c2dc9ed49553b370f"
    sha256 cellar: :any, catalina:      "45fa86f8edbca82be14efe8fd642d1f721e6baffa34d0235cf3f06fb63921a6a"
    sha256 cellar: :any, mojave:        "a749e0d4323f3b6a786b3c6b02f5e90ffd6ce8ac995add8042a4b35484d3dee8"
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
