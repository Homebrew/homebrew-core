# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.0.2.tar.gz"
  sha256 "f7731f1b42acaeaacb8cf7e41c0a472a7aa31a8f47e518baea735f1cb2987e0c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "81528d88d49beaed01ccf668725a862c3b7b4f638788f20790eb7a2246bccff7"
    sha256 arm64_sonoma:  "8ef48fc75f27e4b43574019f6414c636917a94139add88608a209cb73a1904cd"
    sha256 arm64_ventura: "1cfbc564e124c07a9755aa389f7cff7bd9cfd6c6f9064e5f3b25470abe5ef9e7"
    sha256 sonoma:        "015105ec965081a6883b1d33041ca4672783eaa9b4fc6a94c1a5c54baafda064"
    sha256 ventura:       "ce54da3809fdf9dc785ea4aacab36835d485f172251ed3419c5634c6c645ccf1"
    sha256 arm64_linux:   "61573ae598820e04f2973bd40798671b680e10f4bc408289055730156bc6ec55"
    sha256 x86_64_linux:  "c8c07fc5e3c6ceadc67489d42ae57b15123a61d02aa98e776ecd9baaf8e24793"
  end

  depends_on "python@3.13"

  def install
    python3 = "python3.13"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    system "make", "-C", "contrib/chg", "install", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg", "HG=#{bin}/hg"

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<~EOS
      [pager]
      pager = less -FRX
    EOS

    (etc/"mercurial").install "hgrc"

    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # Move the bash completion script
    bash_completion.install share/"bash-completion/completions/hg"
  end

  def post_install
    return unless (opt_bin/"hg").exist?
    return unless deps.all? { |d| d.build? || d.test? || d.to_formula.any_version_installed? }

    cacerts_configured = `#{opt_bin}/hg config web.cacerts`.strip
    return if cacerts_configured.empty?

    opoo <<~EOS
      Homebrew has detected that Mercurial is configured to use a certificate
      bundle file as its trust store for TLS connections instead of using the
      default OpenSSL store. If you have trouble connecting to remote
      repositories, consider unsetting the `web.cacerts` property. You can
      determine where the property is being set by running:
        hg config --debug web.cacerts
    EOS
  end

  test do
    touch "foobar"
    system bin/"hg", "init"
    system bin/"hg", "add", "foobar"
    system bin/"hg", "--config", "ui.username=brew", "commit", "-m", "initial commit"
    assert_equal "foobar\n", shell_output("#{bin}/hg locate")
    # Check for chg
    assert_match "initial commit", shell_output("#{bin}/chg log")
  end
end
