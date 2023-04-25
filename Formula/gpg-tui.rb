class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.9.5.tar.gz"
  sha256 "b5f4b3aa1d66e3de4c2885cc65434a9271f18a7abe4b84dcffa435c5ee871b4a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f984db5d36153833457347b543fe18ff71b9b56ac42d5b385a7afc7de7c9e949"
    sha256 cellar: :any,                 arm64_monterey: "5ca0cb8fe03d73f4950a979cde1e4dfc1ff69e74bdd9155d54f8a4d912303969"
    sha256 cellar: :any,                 arm64_big_sur:  "17f0a44ea40d2ea13e31513f312fb295e3c42a15836a6d66e90e89034bc18385"
    sha256 cellar: :any,                 ventura:        "45bbf07ce995aa966c1cfb76ac5e118b530ee5fc6351612d2925cb4a377fba1e"
    sha256 cellar: :any,                 monterey:       "4bfd79c2f9edf5581c3a8a1216e5fb537df8b70dd08c62a74b32f29207f7b394"
    sha256 cellar: :any,                 big_sur:        "9656d483b1b130737b0a4c918466701b71fd3e8a73020872314c053377d0cf05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c995e2db9d5d485862f8523520894d2a86c4fbf5022b8bb21fa280eb72a0e77"
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
