class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/refs/tags/v5.2.tar.gz"
  sha256 "f166eda5093ac8dcf8cbbc6224123a32c53cf37b82c5c1cb48e2e23352754030"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9661f5ce4e96704568084671343c92755a1de8b542137f0c56e6deb0a6e41387"
    sha256 cellar: :any,                 arm64_sequoia: "68ba1617d44b25cd6bf5e2ae7bb27ce1152a26668b6dd6d4e080d251f7d204db"
    sha256 cellar: :any,                 arm64_sonoma:  "61fbe8b70fbc363a96f266367f6a2daca32f8d2e2ed29df83b633c344369caa1"
    sha256 cellar: :any,                 sonoma:        "24e92f0826f362840d1424012ebf78bd855d46fb827fb253c80e8313c7db137f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10959b02a38dd226bfdf72ee603fab91d6906694584f6d16e25d4ca4450d8a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc7fd26418ce4ac9a9406ef3fd745cdbdb333828c6e0e0fbbfad0dde5b59d10"
  end

  depends_on "gnu-sed"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash" => "nnn"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"

    pkgshare.install "misc/quitcd"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"

    (testpath/"testdir").mkdir
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, pid|
      w.write "q"
      output = if OS.mac?
        r.read
      else
        Process.wait(pid)
        r.read_nonblock(4096)
      end
      assert_match "~/testdir", output
    end
  end
end
