# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.8.3.tar.gz"
  sha256 "f84556cdf9a331984261549d9d08143ab9da33d7c03f0aa323b0ee52d0782a4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7121e5ce7822e823bf331b021d32e87d3584b19e5fbb88153b5ba3e4f2f1a617" => :el_capitan
    sha256 "6523923115d5a141af9aa9af4aceb0ba506fbb8cf11ccb32955498438c093824" => :yosemite
    sha256 "59e1553f61f0ac501a6e66ce643d7ea57f98ac606e589250ad6a0de1f7bd1af3" => :mavericks
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
