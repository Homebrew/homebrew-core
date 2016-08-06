# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.9.tar.gz"
  sha256 "834f25dcff44994198fb8a7ba161a6e24204dbd63c8e6270577e06e6cedbdabc"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8f32d90b3412192134bf5e48c07e50130aaef677af2a2b3004c28e29ff713d37" => :el_capitan
    sha256 "c0c0f949b11df8b62e8c3cbba6b17809a497df40e3bdcf7b8e44de35a0178442" => :yosemite
    sha256 "ce8763d3a99538bc6bb5097e2d4f1894e54c31d6fe0a21b9ab31b0cdd14f19a3" => :mavericks
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
