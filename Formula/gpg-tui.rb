class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.9.0.tar.gz"
  sha256 "7aab4ecaf08bc020e21405e07cac40baf5d11f91e012fdddb4bf1138092eafe0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec8d9d8796f55165941493f1bc17a91567b097b8ddd69671dab60642b8caecae"
    sha256 cellar: :any,                 arm64_big_sur:  "7b7c98635a7fcc508a524325374e45ff5fe031575957052d256b3566a0f95d14"
    sha256 cellar: :any,                 monterey:       "7fa532d99b87cd4b5af650966dbbb1caaaeee8d9dd56488b431e10eeba793818"
    sha256 cellar: :any,                 big_sur:        "127e702384df1496119fd982f180175bfc7d0b517dc6b86b727fee7145be2f78"
    sha256 cellar: :any,                 catalina:       "3995470495945c3b13d0cb3dfd4488240a3bc53a0f079108e6a4e852285eae8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b655ee425c43cda1c81137d49aee7f7c98d92773a3045ce1ae6ca31004656c02"
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
