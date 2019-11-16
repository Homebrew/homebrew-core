# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-5.2.tar.gz"
  sha256 "ff030e923f03ee15c91191996fcb099bfcfa60c7df263be227f67b6a65d36194"

  bottle do
    sha256 "5d02b93a360c6423c6d357d57486b048e41d32b5314d34b52d0fb53d081cbba9" => :catalina
    sha256 "145b59c737eb5a332b38029f36e3837cbf88f15f063fb8642ea066a28971f80d" => :mojave
    sha256 "c28323134e53c09ca43ad1543b034fb54c2558f05ddfead977390899ec2afa70" => :high_sierra
  end

  depends_on "python"

  def install
    ENV["HGPYTHON3"] = "1"

    system "make", "PREFIX=#{prefix}", "install-bin"

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
