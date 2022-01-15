class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka/releases/download/v2.3.8/koka-v2.3.9-source.tar.gz"
  sha256 "ae3e8127b46e51cc4df3525c5f913ecfbaeeb29f0a268e4a3d2e0ac809bc987f"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "vcpkg"

  def install
    system "cabal", "new-update"
    system "cabal", "new-build", "-j"
    system "cabal", "new-run", "koka", "--",
           "-e", "util/bundle.kk", "--",
           "--prefix=bundle/local-brew", "--postfix=brew"
    share.install Dir["bundle/local-brew/share/*"]
    lib.install Dir["bundle/local-brew/lib/*"]
    bin.install Dir["bundle/local-brew/bin/*"]
  end

  def caveats
    if File.exist?("/usr/local/bin/koka")
      kokaver = `/usr/local/bin/koka --version --console=raw`
      kokaver = kokaver[/Koka\s*v?([\d.]+)/, 1]
      <<~EOS
        It seems you have already koka v#{kokaver} installed at '/usr/local/bin/koka'.
        This version may hide the brew installed koka as it may come earlier in the PATH.
        You can uninstall the previous koka fully using:

        $ curl -sSL https://github.com/koka-lang/koka/releases/latest/download/install.sh | sh -s -- --uninstall --version=v#{kokaver}

        or by only removing the symlink (to '/usr/local/bin/koka-v#{kokaver}'):

        $ sudo rm /usr/local/bin/koka
      EOS
    else
      ""
    end
  end

  test do
    (testpath/"hellobrew.kk").write('pub fun main() println("Hello Homebrew")')
    assert_match "Hello Homebrew", shell_output("#{bin}/koka -e hellobrew.kk")
  end
end
