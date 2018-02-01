# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.5.tar.gz"
  sha256 "4d9338d9f9d88dc90b836d1227a3677e3347efaf2a118cc97d7fd1f605f1f265"

  bottle do
    sha256 "59816916c4767f5cb4da8fbcb14d2d47eef667f717a1602197332ed8b93ef549" => :high_sierra
    sha256 "e7efe8fbb0870e4e6376ec64f1d8d6a7ed20d7471b456d43090202829b394b35" => :sierra
    sha256 "3fb4fe819a7c332fe2ac24740c004d904abe3dfd0a902d7a3c97ff3c5d9f15d1" => :el_capitan
  end

  depends_on "python"

  def install
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"

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
