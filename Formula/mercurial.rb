# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.9.tar.gz"
  sha256 "834f25dcff44994198fb8a7ba161a6e24204dbd63c8e6270577e06e6cedbdabc"

  bottle do
    cellar :any_skip_relocation
    sha256 "db15d3613d2fd98424501aa3447b9f4c29c59fe08f8468ae072bec6bbabf3116" => :el_capitan
    sha256 "550f5dd794f7933892ff2e8da1891662aa3ef87d44e56a3389941c766fc16ea3" => :yosemite
    sha256 "8934a8fc26c36e56f017d99ac43a0ebe9d6922f8276c1dfccd9ccb980ae05e45" => :mavericks
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
