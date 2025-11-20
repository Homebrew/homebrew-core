class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/refs/tags/v5.1.tar.gz"
  sha256 "9faaff1e3f5a2fd3ed570a83f6fb3baf0bfc6ebd6a9abac16203d057ac3fffe3"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "653b91dd649f3369be9478ea686a274930f0cf5e17f7c4f67dc6d36ecc2cb06c"
    sha256 cellar: :any,                 arm64_sequoia: "b510e2a0689e2c484874e97b1cf4d3b60cd8a340c40a73b5af35f55a6423c236"
    sha256 cellar: :any,                 arm64_sonoma:  "2a771fbab048f10ec2a1a37d44ff0bf130bd3841a1980b6d2e7d4a5e169f95b2"
    sha256 cellar: :any,                 arm64_ventura: "bb1e86d9a75d29a942d51f17b8022e6441758e8e13da0db2e39bb39a1fd8e18d"
    sha256 cellar: :any,                 sonoma:        "3e411821ea831bb1ba3b184f70a5944505f2d39f0ee888032f8de1ea5c7ba609"
    sha256 cellar: :any,                 ventura:       "56036339638bfde09cdb34ee43fd6d61bcb6142de19e1ce87be7a45144f35a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cb0f12eb1a3d90865bb9b279feb8788bf7f07c53d992fed8c366ed7972f332f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b947a0ee29bb60bd197e0c8ffd0b8ce7d7c9e6528bfa20e0de08aa2477c03014"
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
