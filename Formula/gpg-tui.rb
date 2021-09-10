class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.8.0.tar.gz"
  sha256 "6a9a6cc163e139f03b6983cdb07442187a8e1bcc705698f2b7228ad41c3d3c75"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "60fc3b626cd6b87cd5a3a6eac8a6d54ba4bd36c567192ffd8da39ddf8063a50c"
    sha256 cellar: :any, big_sur:       "63d70ee7c14a915b15ee50c20a486575f6ec227615e25c87d23b66b0159e948b"
    sha256 cellar: :any, catalina:      "143b63d02903a7bcf06bc681056041f097a9b130f37a0839bd7ee28d8c04dabc"
    sha256 cellar: :any, mojave:        "0601ebaeefb30cd91d20c0f87cd7fb2fd2f0a2baa2888dd24192bb75ed88cba2"
  end

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
    r, w, pid = PTY.spawn "#{bin}/gpg-tui"
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
  ensure
    Process.kill("TERM", pid)
  end
end
