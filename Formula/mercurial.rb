# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.1.1.tar.gz"
  sha256 "63571be1202f83c72041eb8ca2a2ebaeda284d2031fd708919fc610589d3359e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c66a096f76d77b35febca52870df73b320e491810587b395ecb72591326d5b4" => :sierra
    sha256 "6f8f61e23762cd42398902f3a4de6568e1c338826b1dce5b3694908d1748c27b" => :el_capitan
    sha256 "0ba0f500d97bfba5715d9bee5407d452e0d9d5bb56f9ffbcdb09dadfcda289ae" => :yosemite
  end

  option "with-custom-python", "Install against the python in PATH instead of Homebrew's python"
  if build.with? "custom-python"
    depends_on :python
  else
    depends_on "python"
  end

  def install
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
