# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.7.1.tar.gz"
  sha256 "8503383c1c31842576516b803d07564216470887ca6388719e4c4089663b410c"

  bottle do
    sha256 "63347ee99f1f71595adc7e7736bc45d75b07f0c97fc791ad4e5002f647214276" => :mojave
    sha256 "2fa3ea5ef0d9ba13ce5b195149f1f82a66e8146f05a469830a786942fc3f839c" => :high_sierra
    sha256 "670c91f394a646b77960809c8a1db3cb67336c599e2a418510709689214af791" => :sierra
    sha256 "1d37cef12a5496c82d1067542e7f2bdc07abe431d0edfbcd45f608b709ff8885" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"

    system "make", "PREFIX=#{prefix}", "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg", \
             "HG=#{bin}/hg"
      bin.install "chg"
    end

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<~EOS
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
    <<~EOS
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
