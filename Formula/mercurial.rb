# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.8.2.tar.gz"
  sha256 "cb78b16956140625266a8a6d1fadc7c868969d994086e1ec60279a66bf20bffd"

  bottle do
    cellar :any_skip_relocation
    sha256 "94962b6d64f6d0f4e5bd147d33b37fa0279a81ea88f503809fa8f5014e0c3090" => :el_capitan
    sha256 "d22a9fea9675ae76154bd86a520440b21af32640afa1dfbd62ad1a767a93e23e" => :yosemite
    sha256 "2734eddaa4e4f3cc71b28d520663572149e03b9dc74d4e51e1efe074b6e0129a" => :mavericks
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
