class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.50.2.tar.gz"
  sha256 "cf9af9bdec5299dc5c541a0feebef9bbb163a2a4151056306f82758290d7a522"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5691550e337c8589419734f7d9101da6683ef6230fbaee8e60e329ed815ad2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7525c50d105f0ccdcfb8a794cec71da7810dc3536d00e4f57b8885ae1fffb284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d8fc1a6c44cd7a417adb8d11d330724fb38213ed7882b5ad58793a4b96edea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7a48b55bbc7fb76e2b88fa4d4912113be57756f62e80b72052945fb9e1ddbc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4b712bdad3c73e42cf93f2c595019afedecd8988867891a726aa230d721ca7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4ea7a0ec33e6ecffeffb54473d4193e2cec486f3d7dad14c00fa4fc51d6065"
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
