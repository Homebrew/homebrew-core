# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-5.9.2.tar.gz"
  sha256 "1edad93096f64d5cae55b9550bb835ac73840c7406861c3cf4e14c3b443bec54"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "22dc7c5e8c4ccbde2cbb38a48757874ef550f07ed7b230437ce3bcb5686e3553"
    sha256 big_sur:       "63e0279fe801aeed18005bb6b642eaea4f793905acc70954e8f4fbeddd328f7f"
    sha256 catalina:      "b96bf65ccd92c289ba9cbd26bb664cc655d72ef17e42c7b47cda64b432aa13fd"
    sha256 mojave:        "9d17a00e32c68c952c38ec112d13db60f622c19b6eeef1b530ae4651a74a8e40"
    sha256 x86_64_linux:  "d0ba37e2a995efd78531979dd8a23607cac15ef3ebe2458e730d069647e3b397"
  end

  depends_on "python@3.9"

  def install
    ENV["HGPYTHON3"] = "1"

    system "make", "PREFIX=#{prefix}", "PYTHON=python3", "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}", "PYTHON=python3", "HGPATH=#{bin}/hg",
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
