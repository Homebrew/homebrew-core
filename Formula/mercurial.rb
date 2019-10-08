# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-5.1.1.tar.gz"
  sha256 "35fc8ba5e0379c1b3affa2757e83fb0509e8ac314cbd9f1fd133cf265d16e49f"
  revision 2

  bottle do
    sha256 "515fe5a3c00988d5069a69ccc9d059277156b91683ad0c6c7e86fa568f2c9b0f" => :catalina
    sha256 "e4fcf22b36669ca85e582121d7365e8d94f4504d7b48dfd518a93e4dbf659646" => :mojave
    sha256 "127344d5ead0a8fbd4cabbfafd7fca4dd4f85f45f260b76e500538c7fd0d05bc" => :high_sierra
    sha256 "9b9f8f096a65d37f2899e7133fb76d64a25be52100883ebd3b7805facc18a757" => :sierra
  end

  # See discussion at https://github.com/Homebrew/homebrew-core/pull/44095
  # plans for Python 3 migration
  depends_on "python@2"

  def install
    ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"

    system "make", "PREFIX=#{prefix}", "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg",
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
