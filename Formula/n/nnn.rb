class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/refs/tags/v5.3.tar.gz"
  sha256 "79ee69f3ced7c0778d207df76b4d4d680636975ccda002eeb19d0917fcba3d36"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1dd1b5e2beda0057209c3d761c8e7bae2b85c8303017640e1a31cf8a797e5477"
    sha256 cellar: :any, arm64_sequoia: "61debb9cf8ceb2589b02888804e7769fb2b861b2879b7a1cbff2a9483af0c485"
    sha256 cellar: :any, arm64_sonoma:  "2893698847a21b95a50d3ba0d084c20942cf2a717cd6844f48e174e3c211da87"
    sha256 cellar: :any, sonoma:        "6aad5d47550a6708d6d3f1fcaff17f8899c89637e49f6e9e035229bf58210e6f"
    sha256 cellar: :any, arm64_linux:   "f5a99600b98fa42c6052f2f22d4796dda2ae0dfebd353ebec157fcddaf98e60e"
    sha256 cellar: :any, x86_64_linux:  "219b9de054400d02c3d1d7b837f5a5c6ecda421c1e7c840e302a53495922e63c"
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

    # nnn 5.3 aborts if XDG_CONFIG_HOME is set but not an accessible directory
    ENV["XDG_CONFIG_HOME"] = testpath

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
