# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.9.2.tar.gz"
  sha256 "69046a427c05e83097bf0145a1e37975ae0b6ba4430456e2beca3d2fd96583cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "a26b595ba43c550dc01b7685c43e6749ede3c3092dd7a0fc9e04c26306fc3244" => :sierra
    sha256 "4145c6ba515903bb49b560edf20e1dbeb2c9043dcd9d4f5670732ff1af5f8c7a" => :el_capitan
    sha256 "bbdc7da69966964f7822c041187b11742366e91cdcac238fe65011cb9f2a154e" => :yosemite
  end

  option "with-custom-python", "Install against the python in PATH instead of Homebrew's python"
  if build.with? "custom-python"
    depends_on :python
  else
    depends_on "python"
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

  def caveats
    return unless (opt_bin/"hg").exist?
    cacerts_configured = `#{opt_bin}/hg config web.cacerts`.strip
    return if cacerts_configured.empty?
    <<-EOS.undent
      Homebrew has detected that Mercurial is configured to use a certificate
      bundle file as its trust store for TLS connections instead of using the
      default OpenSSL store. If you have trouble connecting to remote
      repositories, consider unsetting the `web.cacerts` property. You can
      determine where the property is being set by running:
        hg config --debug web.cacerts
    EOS
  end

  test do
    system "#{bin}/hg", "init"
  end
end
