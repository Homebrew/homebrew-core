class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.52.4.tar.gz"
  sha256 "42806ef717db4dfecba6a2bfa326d97036ea946e4810dd0b7421ed4980f1d4aa"
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
    sha256 cellar: :any, arm64_golden_gate: "a531f8ac867cfcb0d6337172cab9703774508420f92790c8ef40445dfbf8b444"
    sha256 cellar: :any, arm64_tahoe:       "bd735db8e2f23985efb55cf5431df98fa8737a5f0a08943d13d99718187e0d46"
    sha256 cellar: :any, arm64_sequoia:     "40b0a873327d54a350e099b49df1c0550e27ed4e8c17a110e1615bdb3be3ae56"
    sha256 cellar: :any, arm64_linux:       "f6b72822df1830dda4416c5448eb91b8919feed0b899fbe6a832608270f5f679"
    sha256 cellar: :any, x86_64_linux:      "f43e7b90d90bb98791f5156a5cb03b2de030a365564b3008f70b86571c695bc0"
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
