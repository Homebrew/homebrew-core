# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.2.3.tar.gz"
  sha256 "1cb74ca95da021666b5a94a9bdc62f16255a6452f5a84cc2ae71bda8c7dbe36b"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "996a96c5d4d0b00fade895eb75e82e4e28a22bd1939a9fb91e25ff770f02cc49"
    sha256 arm64_sequoia: "d070f09e2846dea61e5dfb2ee8752eb35684d674aeaba1992ca909a0e116a815"
    sha256 arm64_sonoma:  "b76eb3844490a0a45fef1ffa0bfce9b7cf522c547750495564e47e5883dfc913"
    sha256 tahoe:         "5e70f4d8f7b1ad993be3980d01a54b4b8e566f1198e329aa5628204fa6b5ec64"
    sha256 sequoia:       "318af8d936963e85570ba1e765e241218c458f959985ee6ace124dfc60460b0a"
    sha256 sonoma:        "4bc3d08b4c092a5d6f6c70b9ad6e3dfa6583d0f19341bd3100075f8a6467fa61"
    sha256 arm64_linux:   "cfdf0a5f9c9bd1fbd39b48122a1a19d1c3b38aca1d1bec568f5c2027db30eb40"
    sha256 x86_64_linux:  "b6eeb338f31d717ebe1514ffce90342dee598ffdded734def24e720b17945b6f"
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
