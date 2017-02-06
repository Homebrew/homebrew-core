class Grc < Formula
  desc "Colorize logfiles and command output"
  homepage "http://korpus.juls.savba.sk/~garabik/software/grc.html"
  url "https://github.com/garabik/grc/archive/v1.10.tar.gz"
  sha256 "8d65a141c659c5f992b417c15fe8e1283698bb9f39f8b201fd811deb0841d1f0"
  head "https://github.com/garabik/grc.git"

  bottle :unneeded

  conflicts_with "cc65", :because => "both install `grc` binaries"

  depends_on :python3

  def install
    inreplace ["grc", "grc.1"], "/etc", etc
    inreplace ["grcat", "grcat.1"], "/usr/local", prefix

    etc.install "grc.conf"
    bin.install %w[grc grcat]
    pkgshare.install Dir["conf.*"]
    man1.install %w[grc.1 grcat.1]

    etc.install "grc.bashrc"
    etc.install "grc.zsh" if build.head?
  end

  def caveats; <<-EOS.undent
    New shell sessions will start using GRC after you add this to your profile:
      . #{etc}/grc.bashrc
    EOS
  end

  test do
    actual = pipe_output("#{bin}/grcat #{share}/grc/conf.ls", "hello root")
    assert_equal "\e[0mhello \e[0m\e[1m\e[37m\e[41mroot\e[0m", actual.chomp
  end
end
