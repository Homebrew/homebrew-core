# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.8.2.tar.gz"
  sha256 "cb78b16956140625266a8a6d1fadc7c868969d994086e1ec60279a66bf20bffd"

  bottle do
    cellar :any_skip_relocation
    sha256 "3144898b22ec2d764d0c4bf39735ac5b097e2d7aec3366b2db13f3dd5b6e5ca7" => :el_capitan
    sha256 "386e2a3049991fa1b1325db19416cd45c8cb569770a35b46940c50084527bc16" => :yosemite
    sha256 "3eb31747821c59fe8473754c39fe68c5d9429cfdc6a2adde987b348ffa5572d7" => :mavericks
  end

  def install
    ENV.minimal_optimization if MacOS.version <= :snow_leopard

    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # install the completion scripts
    bash_completion.install "contrib/bash_completion" => "hg-completion.bash"
    zsh_completion.install "contrib/zsh_completion" => "_hg"
  end

  test do
    system "#{bin}/hg", "init"
  end
end
