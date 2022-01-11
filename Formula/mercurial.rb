# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.0.1.tar.gz"
  sha256 "05fd0b480389c96547f5a6c769e90ee00f1d13f7ac0d465e40a381c6cf3a56e2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9b729e24f606d7de61f824d16e5b9c83bad97cab4bb2202619ddb922b2a02110"
    sha256 arm64_big_sur:  "15d56b6215edf56fada3dce41d6403f1ce52ced10ee0d4b28d312a897d2780ca"
    sha256 monterey:       "d03179e44f80b5ebc04634cf39a4b11a3f30ec73ed2688246853c57316ee281a"
    sha256 big_sur:        "459ad969cafefa1d4f2b12b06771ab031bc98d033bac58f8000b3ea187f611ff"
    sha256 catalina:       "d95d6ed1f4d4fffff85da10dbaeb7102ea3cce4db6ec13edc6c86411b0d86ec4"
    sha256 x86_64_linux:   "fc73709c8fbb7b801e4c243d05a9cc6a279e6d2f043e18b49ecf9039a6b99fca"
  end

  depends_on "python@3.10"

  def install
    ENV["HGPYTHON3"] = "1"

    system "make", "PREFIX=#{prefix}",
                   "PYTHON=#{which("python3")}",
                   "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}",
                     "PYTHON=#{which("python3")}",
                     "HGPATH=#{bin}/hg", "HG=#{bin}/hg"
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
