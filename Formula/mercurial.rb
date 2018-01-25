# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.4.2.tar.gz"
  sha256 "dc2f72caccd6b760226753d48c2f4e8889fe176a6b23ef50775caac55ce28b85"
  revision 2

  bottle do
    sha256 "aa8701f010da5025791330887f22f5e6b8a68312dc286bf935af535ef958989f" => :high_sierra
    sha256 "dabea6811809e3ddc437249373aea7cb1839e02cd8bb7c1a1e7d9cac4890831b" => :sierra
    sha256 "0312245445bb2f0a5cee0607fbbcce4ccc1040d9a087ff67918da2c145f8827e" => :el_capitan
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
