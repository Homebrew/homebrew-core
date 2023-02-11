class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.9.4.tar.gz"
  sha256 "37645b53a5969fe976ca2520ed81f54d88d65411c561389f7f9e773eb5247fd9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2e353fd9bc26c33086a4c4583ff02cb468cc344f85db43e7d402d60bae3c49c7"
    sha256 cellar: :any,                 arm64_monterey: "aa8120deda67e09c33a89ac40d5ef69d3f12579058584c38c177e276eab7233c"
    sha256 cellar: :any,                 arm64_big_sur:  "c4ca47774d5a6369552733a2de45fccaa308ab753ba6b26ee82779e915cf686d"
    sha256 cellar: :any,                 ventura:        "0fb00a885b61b4c15148165542f0d0f0eea10fc11e706c5492648a372bce60c7"
    sha256 cellar: :any,                 monterey:       "a78837041fbe8ccf2778f680354b90f136109e93fb262baf1c95517f147b995b"
    sha256 cellar: :any,                 big_sur:        "e81f03f83316015331619396cb9fc401c565cca8b1e8d60b30831d2ac65b69f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99235c515ba9c469c14478f496182080e96e9bce7d915b316579b265884d2e01"
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
