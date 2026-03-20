# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.2.tar.gz"
  sha256 "a250227eba47c6ad5aa32b9a72281343762f5d274ff38c53c2f43df5c63af3ec"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bb3d00caf9bf1b096f2550df2abdba9697da92594722e9250938fd470aa1861a"
    sha256 arm64_sequoia: "750a601be77890d692cb3dd9d96fc6b6c66ae04f5dc2703b84e43e545ca7818a"
    sha256 arm64_sonoma:  "24741c5c01e285a9ce83154f50ee690a457dae2bf896eeb58ca7a98c0b880980"
    sha256 tahoe:         "dd224b1a49ef2e0c8ae23447910be5343f4c36df89fe34c900379216cd33103f"
    sha256 sequoia:       "0d73563bd306862d37fd976d6a000ced70d86deb5a692ef20449810b94e13959"
    sha256 sonoma:        "82e12965240273d65f8d98131a3cf2779d2bee5dee1f008dc7a48ae670ae0957"
    sha256 arm64_linux:   "226d8f4d00541ff48163a76d4d29af196bb725264d8cfee14708008b15406795"
    sha256 x86_64_linux:  "54c23ed133b8a3c1484df8b07a4b7729358029eaa328d968c850c1f8344c0f44"
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
