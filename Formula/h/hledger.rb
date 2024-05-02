class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.33.tar.gz"
  sha256 "17de054f7f06e30099bd657a3af199e5d3852d365717301990c99baeb788988b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "154747adb6a8828f94c36c2a2fc8086e08e5733fb35f0ec788381d63e86c50c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "701bed82e38fdaf6a46dd542ef9851ecdbf188c36742fad07a6dd4e33534e018"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1df08340a84bc82d11671d2b2d7405aee9bf9ab6d3d460a9d78721768161e23"
    sha256 cellar: :any_skip_relocation, sonoma:         "791308be3442b4ee34ecf3ac4794efc9a206dcee9e4f3dc6f5a68c31454d46ae"
    sha256 cellar: :any_skip_relocation, ventura:        "88ace5a974abe8196f94afef7fdd83050be2c95f2ebfcc71a705b6007c1079dc"
    sha256 cellar: :any_skip_relocation, monterey:       "62ad2fc2fd50e3635cf5192a39a54953ab29c3a76d80210f8a4c059245f29e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbe48bcc2ce111b69e8e0de94df7fa1b2d73150fae4f7c29dbf11ca78dbd569c"
  end

  depends_on "ghc@9.6" => :build
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
