# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.9.2.tar.gz"
  sha256 "69046a427c05e83097bf0145a1e37975ae0b6ba4430456e2beca3d2fd96583cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "08a7b1da5591b635591c396be1e82a9ebb01287e62ed20cfe23a7eb469999bc6" => :sierra
    sha256 "7caf435412d9afedb8d3a0466ff42352ca48e9406416875204399bef083fc57f" => :el_capitan
    sha256 "905f27516720fbbf6f9668ef1be96c51a54822c8f0485e1e106a8832646ce8d5" => :yosemite
    sha256 "08f93cc3f6aaa7f46f42a3475c91eb07e634019fb397f7cb886c4f917a116d9e" => :mavericks
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
