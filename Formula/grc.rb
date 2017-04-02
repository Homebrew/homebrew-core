class Grc < Formula
  desc "Colorize logfiles and command output"
  homepage "http://korpus.juls.savba.sk/~garabik/software/grc.html"
  url "https://github.com/garabik/grc/archive/v1.10.1.tar.gz"
  sha256 "2ee6f2b798a3c39064e41f388605d35c1964711445974e0e5bd384c339195c27"
  head "https://github.com/garabik/grc.git"

  bottle :unneeded

  depends_on :python3

  conflicts_with "cc65", :because => "both install `grc` binaries"

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

  # Apply the upstream fix from garabik/grc@ddc789bf to preexisting config files
  def post_install
    grc_bashrc = etc/"grc.bashrc"
    bad = /^    alias ls='colourify ls --color'$/
    if grc_bashrc.exist? && File.read(grc_bashrc) =~ bad
      inreplace grc_bashrc, bad, "    alias ls='colourify ls'"
    end
  end

  def caveats; <<-EOS.undent
    New shell sessions will start using GRC after you add this to your profile:
      . #{etc}/grc.bashrc
    EOS
  end

  test do
    actual = pipe_output("#{bin}/grcat #{pkgshare}/conf.ls", "hello root")
    assert_equal "\e[0mhello \e[0m\e[1m\e[37m\e[41mroot\e[0m", actual.chomp
  end
end
