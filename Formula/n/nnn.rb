class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/refs/tags/v5.0.tar.gz"
  sha256 "31e8fd85f3dd7ab2bf0525c3c0926269a1e6d35a5343a6714315642370d8605a"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b779d56e7e4b37a45f6ee35a094de4f7bd421f7c4468daa4b5bceb2c45e627bc"
    sha256 cellar: :any,                 arm64_sonoma:  "4de486092ffb8baf66e4134ca7932208bff0eab3a1f5ec7066727b10f4abcf2d"
    sha256 cellar: :any,                 arm64_ventura: "5f34f95c87192ede70063f4e5d6ea3ed89284e5af05e1bfe6eedc2a4d2a93173"
    sha256 cellar: :any,                 sonoma:        "ecdfa7050c0d271f5310f33640f449c42de687dbbc1a4327299d261a60944f09"
    sha256 cellar: :any,                 ventura:       "8038dc7a4cdf73e5283f4bfa466b0f5dcbc0dcf67df28bed6866426ca2084ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d0686c85db1f495303f9998a382a5d88911c12f0e663eab48b20a1ccecbbb11"
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
