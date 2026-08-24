class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.52.1.tar.gz"
  sha256 "242ba652cb76b2ca5cab1ba7588d0c99c8b7ebb329d76785f1851f2d5e9e95f6"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "main"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "92aa1ed3e0a80dae9261b988c4b6828d8a87b99b068be39a290e692f7525ed38"
    sha256 cellar: :any, arm64_sequoia: "635f433df126a6367b128a65c48127cd3a6b346fb7ddb5b8bb06484f5f2278ad"
    sha256 cellar: :any, arm64_sonoma:  "4056ff0483d2b05cd6997c1a21fb3b12e27e79ecc0c9acc624ddcef5033478ed"
    sha256 cellar: :any, sonoma:        "07a24492b09eee41d831b76297d5ffee6450af23b73184d066036e960823885e"
    sha256 cellar: :any, arm64_linux:   "6275cbd25abd4449722d1e6abc4bbe19769246e0753f9799b3e114495b6f8e5e"
    sha256 cellar: :any, x86_64_linux:  "dc62de3a7c6c47e8076e0699e9248aee3f31c937de03378003b24b89ca97781a"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libyaml"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --flag=libyaml:system-libyaml
      --jobs=#{ENV.make_jobs}
      --local-bin-path=#{bin}
      --no-install-ghc
      --skip-ghc-check
      --system-ghc
    ]
    if OS.linux?
      args << "--ghc-options=-pie"

      # Using global configuration to apply options to all dependencies.
      # -split-sections helps reduce installation size by over 50%.
      Pathname("#{Dir.home}/.stack/config.yaml").write <<~YAML
        ghc-options:
          "$everything": -split-sections -fPIC -fexternal-dynamic-refs
      YAML
    end

    # Let `stack` handle its own parallelization
    ENV.deparallelize { system "stack", "install", *args }

    # Strip binaries to reduce size by ~100MB (~25%) on macOS. This has no impact on Linux. Also done upstream:
    # https://github.com/simonmichael/hledger/blob/hledger-1.52.1/.github/workflows/binaries-mac-arm64.yml#L156-L158
    system "strip", *bin.children if OS.mac?

    man1.install Utils::Gzip.compress(*Dir["hledger*/*.1"])
    info.install Utils::Gzip.compress(*Dir["hledger*/*.info"])
    bash_completion.install "hledger/shell-completion/hledger-completion.bash" => "hledger"
  end

  test do
    system bin/"hledger", "test"
    system bin/"hledger-ui", "--version"
    system bin/"hledger-web", "--test"
  end
end
