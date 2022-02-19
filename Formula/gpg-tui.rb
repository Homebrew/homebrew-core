class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.8.3.tar.gz"
  sha256 "64e0159c997b97fc6896ed6fb5e50d65d50e6c08c14817bea7b9be5a70335442"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f32f011b86a5b4486d8e158ea63f584f11d1d843c1e45a963fcd36398bca5633"
    sha256 cellar: :any, arm64_big_sur:  "373c902b22f96555c932debd7bf670cfb2295665036152af35756e861750c281"
    sha256 cellar: :any, monterey:       "d3d8845b271c34474a60f7289884411079dfde7a4c6bd4e1896763eab78cfb2c"
    sha256 cellar: :any, big_sur:        "6458de475f07b87312fa200dfee47d73b4b9e24c2d2dcba8c66159bfdfb3d809"
    sha256 cellar: :any, catalina:       "a147e0ba307560846208534dfd3a8409e77d070dcd8a072468a6c33fcd66bd58"
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
