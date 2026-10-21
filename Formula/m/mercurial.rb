# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.2.4.tar.gz"
  sha256 "85839e0f39e6cb893a88932aa36ef661759f3c5c5de4551ad26bd9df53cb71a2"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "d363fcc95236e6edca3bac88da8980df936f0b5463cf756a5a164e7c14de80c5"
    sha256 arm64_tahoe:       "ebf09fb38004564a0ba4a541fd76311f81e3d6dfbdb62f50500747b83cbb3482"
    sha256 arm64_sequoia:     "2eb365be6ed29ed8660821e397bd642109e1737dc260985c03c3249c5373a6a5"
    sha256 arm64_linux:       "d98dadc553aeec645cb1474f907c32eeacfb21a3a1a0dba99a221fdd06fdfdbf"
    sha256 x86_64_linux:      "1c0d442b34cff0e5d7ad3ecd0e09a6b65b0b4fb5718c6426889166b70bdc6710"
  end

  depends_on "python@3.15"

  # Backport to support Python 3.15 with OpenSSL 4
  patch do
    url "https://foss.heptapod.net/mercurial/mercurial-devel/-/commit/5f775798ca43e215b6b190a88733ad8751beb90c.diff"
    sha256 "67d80601f03b08b7691511094647bdd2b6b438edcd09ecdcf1e1150b5b1216c9"
    type :backport
  end

  allow_network_access! :build

  def install
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
