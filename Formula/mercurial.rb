# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.8.4.tar.gz"
  sha256 "4b2e3ef19d34fa1d781cb7425506a05d4b6b1172bab69d6ea78874175fdf3da6"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b0083c13264bef0a98ba30d231f5c65ebfa8ca2c75daad028559c73afe2aa74" => :el_capitan
    sha256 "713df1a367af55b03e5c3a853e5a963f32d8cf33dcb8c0ddb6c388603a3d8cc3" => :yosemite
    sha256 "b038a222b9da243d0c14b88e370f4912cd5b790b7ae1cf4bc14f0fa1c24120e2" => :mavericks
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
