class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.8.tar.gz"
  sha256 "0a744e67a0ce8b5e1e04961f542d2c33ddb6ceed46ba760dd35c4922b21f1146"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d5f557981513afab9592ea456b58bf6a4ba752cc7e2ce79e0fa53b21a2fa21da"
    sha256 cellar: :any,                 arm64_monterey: "91c6071b99b909d7b9e05e13bbd46db7e936456952a2e78da0fc8d387bddf0b9"
    sha256 cellar: :any,                 arm64_big_sur:  "bf095fffb53cfdc30866b394a01c683bf2bf29792fa7ef3a315fd7897e50fe66"
    sha256 cellar: :any,                 ventura:        "6975527088a5fedfd9b8b848aafa73ceefe100a2971d2c7f12fdcfd3f04f4aa1"
    sha256 cellar: :any,                 monterey:       "da5c72abb656d4bb508393d3a8ad2ae02d65115b3108b85bfbb2f18be10920b6"
    sha256 cellar: :any,                 big_sur:        "5336ef7d41f43071e8538af0fb94ac16521f51fbc0385faecce9b63e733148a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f02c735de7f1d4e3a483244eebf4170a5482c0b76f7dfbf5bb9c16fe30cf316"
  end

  depends_on "gnu-sed"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"

    pkgshare.install "misc/quitcd"
  end

  test do
    # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
    # Fixing it involves pty/ruby voodoo, which is not worth spending time on
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Testing this curses app requires a pty
    require "pty"

    (testpath/"testdir").mkdir
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~/testdir", r.read
    end
  end
end
