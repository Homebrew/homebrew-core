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
    rebuild 1
    sha256 arm64_tahoe:   "3f23c96102f486deb07929d7d463ca56e004fb83a7d265a09739494a98a6b39d"
    sha256 arm64_sequoia: "8f38a7369f1c3534814df0161f16b557dd0bf0d7ef6e816619867691e4d186f2"
    sha256 arm64_sonoma:  "50f59d6380b7941faf5ae93e5beb6a5062cd15eacfb164e8052d012edac753fc"
    sha256 tahoe:         "697c91e7458980320413fbb7854b43de0198eda8f3464dc47fae3d00b94d6bd3"
    sha256 sequoia:       "89927f08339b4f7a7b026695ca86f207914a654fbbcf485ec967d00794fa7c9b"
    sha256 sonoma:        "4fd2dd0923dbc0ee547fe8ed6daa9309a0a111459240d55c2c7733bcd6b4d88a"
    sha256 arm64_linux:   "6dc47f8a40ed7e5905b02d0a3966c01abc2793ced66a65f2e259f790f2fe54f8"
    sha256 x86_64_linux:  "809732bbaea666c4ff3565da49007ece08c23e4495e7ad5e5e1c3b2d0b97f99d"
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
