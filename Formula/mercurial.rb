# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.3.1.tar.gz"
  sha256 "2b12f02e3a452adff4ec9cf007017bab0cadb3f37eaf12f4b25a662df73618a2"

  bottle do
    sha256 "d31c955d76b1694ac96b5238ce1953617394569a3f4188cb2f252f4c7e2e8cdb" => :sierra
    sha256 "7654af276b4a407294b66386615576d178380cc1ff1200bff7ab41e9af5ae024" => :el_capitan
    sha256 "33a6d86226b197e52b8766c12ce633e67eba4393c8b91e0cf33bcef582d55510" => :yosemite
  end

  option "with-custom-python", "Install against the python in PATH instead of Homebrew's python"
  depends_on :python

  def install
    system "make", "PREFIX=#{prefix}", "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg", \
             "HG=#{bin}/hg"
      bin.install "chg"
    end

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<-EOS.undent
      [pager]
      pager = less -FRX
    EOS

    (etc/"mercurial").install "hgrc"

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
