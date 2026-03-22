class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.52.tar.gz"
  sha256 "5da2baa4cdb8a391961c66ad2b9d502898f0d7cb534c07703ea05696475ea42b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "77ab2f1fd71757c8902f2f6e53e2d5c67653e6d31d3fd231216fffd09aebbcd4"
    sha256 cellar: :any,                 arm64_sequoia: "f4424389b4191b7f027624c750b7e2955b61ab900eee85fddc85dda5b60c665a"
    sha256 cellar: :any,                 arm64_sonoma:  "0fbf25faf6f31f7af7f5bd2670f4a7e1914b4855f71a1622b05b93880e28a154"
    sha256 cellar: :any,                 sonoma:        "5c34c6349ed9b32a0690b02f215d82a9a2f12aebd6e72a9e80cc470f3290b47c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8df4e6f3f40c895abc80dda7c0161c63ebf6e46ea9ea07bb55c6030d3889ebe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f098bd1c127e3475a312eb996b374c80e36e33e1c9c6844522556499ed1ce77f"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
