class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.9.4.tar.gz"
  sha256 "37645b53a5969fe976ca2520ed81f54d88d65411c561389f7f9e773eb5247fd9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4969367e72f48de7f25bd381f888919e37fe8c553d14b9440a6ab2b104f2167"
    sha256 cellar: :any,                 arm64_monterey: "337cef81506411638c8c107ba3886b1e06e37c690d05d6e303c9036a243c22a7"
    sha256 cellar: :any,                 arm64_big_sur:  "2c30fd4b4933fd4dc62f2fb926ef967284fc9352db7411c80dfd00dcd7a16ea9"
    sha256 cellar: :any,                 ventura:        "9a2f494cc64d0eacf9e0236bd73adc272bd73a1bac5da5dbf7be2912821fe64e"
    sha256 cellar: :any,                 monterey:       "10ac3f7d21f15b4f01c38d6b8ecb5acad14d9090a1ad8d78c0e9a0315e5d7802"
    sha256 cellar: :any,                 big_sur:        "2337c41c8af7f7163b16a2108847fa7a7c0cbecd526064459446cb1d8c1f1b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6350e86b35b0890aade6d50b5cebb727457922b88748b06c7dfacf758213132"
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
