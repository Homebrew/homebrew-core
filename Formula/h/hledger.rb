class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.43.tar.gz"
  sha256 "6118e08a7c5e2bf37d96ae36f351f778a9a1efae8d5a010da97cd6716c1fb080"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49f7803f450afddf5c5450165ff148a012c7991e6d6cc6440ffdd66299fa622c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1e3b85a8c0d203f8e7b78f8c1f12ece76f77fcdcdf5900f797b48bdee1e53e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd3ee42d4381bdc8d469771af6d03e3554c3b5b7ff878705d516ed76416fb362"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0a08f2cbc27aa416dcbbb07fcb9fadef3dbc5e5974da99b6223b544e77b8a25"
    sha256 cellar: :any_skip_relocation, ventura:       "a21cc3fe55faac6a330264377dcb3ba3b7f9aef75798ea22ce0a42b14b1578e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ddbbe6309e75ff4f84906ba7a21c7144a171b0ddca1f6ff958b9b950102904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56171e60429aa7fafe89049f2b582f59a983b4c3ff12a1280ee2fad7a0131101"
  end

  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger*/*.1"]
    info.install Dir["hledger*/*.info"]
    bash_completion.install "hledger/shell-completion/hledger-completion.bash" => "hledger"
  end

  test do
    system bin/"hledger", "test"
    system bin/"hledger-ui", "--version"
    system bin/"hledger-web", "--test"
  end
end
