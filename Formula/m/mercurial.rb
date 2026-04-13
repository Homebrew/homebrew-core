# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.2.1.tar.gz"
  sha256 "f750f86c5734a8df776a003db45e9a9df4e398a770479ea4cc19b61e9f3acd17"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c1e01ffba2cba593f92cbcc237cd240505bc5fe79450a31783d0cb2cc4259c84"
    sha256 arm64_sequoia: "2e81ec73a58dd9baa092ceef91982aa83ccd2339be24576308f3a7febaca70a8"
    sha256 arm64_sonoma:  "b7fc40a7bc93c71f02dbac91673ff199be7107fd993c71c663db794e46dc45d7"
    sha256 tahoe:         "b2a63d68506cc4fdb5b53d752dea1e74147b0b7f90b74fd126fb6eac1ce6d4fa"
    sha256 sequoia:       "ed556a41b308048e952c2bdddaee5fa7a9cca5901c341b9fc44545a3f9db64df"
    sha256 sonoma:        "b597d2978873edeefb8f2064cf469afc1c0783bcec92397e1830181a71c1b23c"
    sha256 arm64_linux:   "2b063d35baae67536b02ff614c49ff6b54079fbfe9804fed7376f24382ba7bbd"
    sha256 x86_64_linux:  "5dbc2c85287e270559bf0a23c8d73db0ae4cd03cd40192b90fef93b45d8eb020"
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
