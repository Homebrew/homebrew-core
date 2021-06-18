class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "6bbcf891e4d3e2b31a9d7878a4812d84ceb3b3ad294929b7577a68169a66dd3f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "21f6377efdd94fe8c42ada631a217711c4acbe47d2a1f736f8fe23a08699a893"
    sha256 cellar: :any, big_sur:       "0ae12b66b1b6f114b65d49111b25c319cf74055178cfae2451ca4bd893ff1d41"
    sha256 cellar: :any, catalina:      "91bbca2cb93de4c4fe930d563a74f29c7d5a7c7cf0ba2f8769883d5a12cb53ad"
    sha256 cellar: :any, mojave:        "29b65d84ad6b6bc5c87287e45e7c61010cd396c23d3725b9612d7bd586865d87"
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
