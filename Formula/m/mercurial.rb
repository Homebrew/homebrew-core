# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.7.4.tar.gz"
  sha256 "74708f873405c12272fec116c6dd52862e8ed11c10011c7e575f5ea81263ea5e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ad5cb55a0eda86caf7d91c55426817a02f9d7f97d1ff85273cb37cbba3710975"
    sha256 arm64_ventura:  "e6361d0554d0548f6a429ba509bff1734942482f1a54d9942ddf189d77fc6897"
    sha256 arm64_monterey: "4e995a63b11b5e170f5a14f3c65328dea10aaaa012c682dc643b216973dab52d"
    sha256 sonoma:         "0d5ae58bb704086b798f486a650a9c21ddf109a8b1b1f009ac8d13723df03ec2"
    sha256 ventura:        "ac7b39adecea1de3943b6681b95ef8e4982e35a912e19b41464dee0ff5bece2c"
    sha256 monterey:       "2043c1a4e3f67e4ce0e2950266c647bbdb67d4c90f6c37eafa823e126c665a3b"
    sha256 x86_64_linux:   "0225e72fed5e22d30403d4b5838a46b84234fdde4f7ef5f4a45ea60ada72e661"
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
