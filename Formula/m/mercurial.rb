# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.7.2.tar.gz"
  sha256 "1c22070c05dfaac41ff88a39ce2508dde480f0dd05d45d7efab4c5cdc6ddd806"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "53fde9079a30d9a233a01e9931efe6e0cd533fe1c7090699ec83670b0c9f4c5c"
    sha256 arm64_ventura:  "1c59482e114bc8ff9c384a49629d085a0c59aa6d56ebf0ce9e4b4111588681ac"
    sha256 arm64_monterey: "d7f415916bff848bc421573ed4b8a6610460ff6e4d635ff4d2f75883bc6463f0"
    sha256 sonoma:         "1b27e2b27c2e47f66c7fed2a7f5347c3008f71fd3aba070d9126474147ab8f83"
    sha256 ventura:        "af2064a05a5f31a4a6e5c41797b5e1d77ae080c4c218cf3ea2ec6308e957ae08"
    sha256 monterey:       "3c92d419e98dbec45010f696e20911b76e3829ce798e17eb828d70d4a6faa5e5"
    sha256 x86_64_linux:   "96bad82d7d2c5fad16842a3dc8cd0a06559b687b27a82fafebed5df52150bfc0"
  end

  depends_on "python@3.12"

  def install
    python3 = "python3.12"
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

  def caveats
    return unless (opt_bin/"hg").exist?
    return unless deps.all? { |d| d.build? || d.test? || d.to_formula.any_version_installed? }

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
    touch "foobar"
    system bin/"hg", "init"
    system bin/"hg", "add", "foobar"
    system bin/"hg", "--config", "ui.username=brew", "commit", "-m", "initial commit"
    assert_equal "foobar\n", shell_output("#{bin}/hg locate")
    # Check for chg
    assert_match "initial commit", shell_output("#{bin}/chg log")
  end
end
