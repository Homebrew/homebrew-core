# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.1.2.tar.gz"
  sha256 "09415253fb409a77e19b9951532a3c22c4e07e74bab80652527064617daab194"

  bottle do
    sha256 "e92f908a16b3f63edc454b77d0bf71c6dccf7b837158810a89f81500d4530d91" => :sierra
    sha256 "320248e9abe5f9921133b620bd07f1861afb99e98b961c2d672db22ae21ff1dd" => :el_capitan
    sha256 "1ee69985b76d6ab5adfcd797950d862b2655aa29a5e15a50f6488132faf19a9f" => :yosemite
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
