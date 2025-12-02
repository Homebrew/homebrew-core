class Grc < Formula
  include Language::Python::Shebang

  desc "Colorize logfiles and command output"
  homepage "https://kassiopeia.juls.savba.sk/~garabik/software/grc.html"
  url "https://github.com/garabik/grc/archive/refs/tags/v1.13.tar.gz"
  sha256 "a7b10d4316b59ca50f6b749f1d080cea0b41cb3b7258099c3eb195659d1f144f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/garabik/grc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "7a9655993b72c5fa50ecd3e530cdb69ab9da8c0fc4f9352786b10c9529d26cc8"
  end

  depends_on "python@3.14"

  def install
    # fix non-standard prefix installs
    inreplace "grc", "/usr/local/etc/", "#{etc}/"
    inreplace "grc.1", " /etc/", " #{etc}/"
    inreplace ["grcat", "grcat.1"], "/usr/local/share/grc/", "#{pkgshare}/"

    # so that the completions don't end up in etc/profile.d
    inreplace "install.sh",
      "mkdir -p $PROFILEDIR\ncp -fv grc.sh $PROFILEDIR", ""

    rewrite_shebang detected_python_shebang, "grc", "grcat"

    system "./install.sh", prefix, HOMEBREW_PREFIX
    etc.install "grc.sh"
    etc.install "grc.zsh"
    etc.install "grc.fish"
    zsh_completion.install "_grc"
  end

  test do
    actual = pipe_output("#{bin}/grcat #{pkgshare}/conf.ls", "hello root")
    assert_equal "\e[0mhello \e[0m\e[1m\e[37m\e[41mroot\e[0m", actual.chomp
  end
end
