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
    sha256 arm64_sequoia: "adcdd94f98f4e8214b39b1146dfc80d506147de819550038c96b960ecff9eb0e"
    sha256 arm64_sonoma:  "3fe5462406773aa19b203c2ca413acfa8f71e1efe7ab1c36ddc547d878fda0d3"
    sha256 arm64_ventura: "0429c995db285cbaeb2efc82b1d33ad2046cb664de0fc80ea08893ce2553a880"
    sha256 sonoma:        "e1821949354dd3457e591a72600497769e419a52d2fc64136ba74974e3fc20bf"
    sha256 ventura:       "9a7a4d71679097671e9fbc6c06c5d148c037676be4b08e163c936bb69a55654a"
    sha256 arm64_linux:   "7c5d9f264c42b27e1e2082feb8330eea70dc8e949230b3a2dbdf5796274a123a"
    sha256 x86_64_linux:  "5b9a76306427e100dd319136e80aede8e5b0dba734a1b788a57a9308f49c5932"
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
