# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.2.2.tar.gz"
  sha256 "f2ec8e7eeef0500591706d374555f0ceb118822068e75fa3b32be07dd2184f6c"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b314da34e74eee6b843b2a2bc2141e7c77c2129b1340b4367873c8e53caa2b2b"
    sha256 arm64_sequoia: "eb887e2837d02a2b43f72b5e60783f684bdec624424936da1815a9d2b5ae7672"
    sha256 arm64_sonoma:  "dcc8b398239b62564b5f4dba1c93ab28afbfbc76c4e723b8c9262806ec5ce6e0"
    sha256 tahoe:         "8926c3ed03a73f54083cefd3d6df30defed4302ca1ca00f478bee73f67a39d1d"
    sha256 sequoia:       "4a13d61d6dff17789f5184ab8e598645f8c767c8c345fd3c5f0e1f4fd0b6756e"
    sha256 sonoma:        "ae95fd5003ca3c57b9c52fcacc624522fff1332ad914f269fff36095908f0805"
    sha256 arm64_linux:   "3c58bf407be023e33b32ed507322f86f5751e59ee5e7bbb58ec758f31f9c078f"
    sha256 x86_64_linux:  "102cd57c321bd30309e3752172776b44a7a039ab7e75137383ad45abf2e7cbc2"
  end

  depends_on "python@3.14"

  def install
    python3 = "python3.14"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    system "make", "-C", "contrib/chg", "install", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg", "HG=#{bin}/hg"

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<~INI
      [pager]
      pager = less -FRX
    INI

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
