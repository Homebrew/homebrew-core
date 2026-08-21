# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.2.4.tar.gz"
  sha256 "85839e0f39e6cb893a88932aa36ef661759f3c5c5de4551ad26bd9df53cb71a2"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7f52a7affab2e09b5ec08bbafa6d6a4ebc1cf2b37e2b98c90ce686264744bbe7"
    sha256 arm64_sequoia: "ffd20e262451e1862f127f8e75d648ecda78bb6589f2b354d559d9df84aa3822"
    sha256 arm64_sonoma:  "f3f855fe4266ebe8b38c83d5d70fd345997fae94ecef8bf6ffc72bc1bea2dee1"
    sha256 tahoe:         "c7b9d6bfc7ab3058a5bfb785d4adabd3b8f7f54727d948e799d2c3c9382b8bb7"
    sha256 sequoia:       "cafcc38e97898eb6e59f55687243975cb4a87f92c961b72a5ab43ae1c35a7a4c"
    sha256 sonoma:        "84332e34f88fe9c9e6145e6481b5d6b040ba6145c20f467f546c6eed7bad97bc"
    sha256 arm64_linux:   "a092320a52ba91f68c03739001c8e839ada479e160d089bf910d15feded01832"
    sha256 x86_64_linux:  "d10aabdfebac0890ed4a50783eaea66569f09b0a0519de3ef4f4c2efdff5f859"
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
