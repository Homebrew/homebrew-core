class GpgTui < Formula
  desc "Manage your GnuPG keys with ease!"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "741def01fe84ee20c3eac1cbbe2533e1a9c387832cab31b5d233062338254ce1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "83318b5d6c2572642cd4cdabadf1f4411c3b59d4b8d1d36efdb5440a84ecc726"
    sha256 cellar: :any,                 arm64_sonoma:   "8a5f8cfea861d52c8e83459bab25140df30632087ccb626f3b37b6342a94900f"
    sha256 cellar: :any,                 arm64_ventura:  "b2b9e2574869dd0a954d772e3baa52833e6353e8ddaf500d69e8bb12502e8987"
    sha256 cellar: :any,                 arm64_monterey: "839bd1b54c25768ee1a8a7c86dd96c38ca313eb2cbe3c9029e9780d43423ac67"
    sha256 cellar: :any,                 sonoma:         "003cfc65824809391ce325ba7e70041149a1c31a8ff093071d891ebdb5fe05e8"
    sha256 cellar: :any,                 ventura:        "8420ac55ac0ce5f3d020660a6a8033dff374b48599f3ef1f7e96dc6e5135398e"
    sha256 cellar: :any,                 monterey:       "62d158f8de0104dbda18ff48f8b17bad1d5d97514067e5f87537e25f2fe333c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b326e5cb490b82f26db74f3c98efbcaf2b361f43ad6041129c6fd33645185f8"
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

    rm(bin/"gpg-tui-completions")
    rm(Dir[prefix/".crates*"])
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    begin
      r, w, pid = PTY.spawn bin/"gpg-tui"
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
