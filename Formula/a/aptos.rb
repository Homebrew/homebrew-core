class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.2.0.tar.gz"
  sha256 "d53de81b88c5fb7f190901b7be3e570609f2bcccfd91eb0280bdd9cc2ec4ca6e"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da64b3ad497e803671c991353cf17a0f3431f8e300e40bd13fae93b5966df1c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d348028157bf0e08caf32435bd27da5a86094d53ed8abb5fd785155cfc5a4aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63c6d8ce67534640bc2e47519f08aa5c9c3a1057dffc7ceb19d05e6a45fcfed6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b53dbbcd6bf787177324dd43d3f9182864b5b17e35fb7c12e24bf4e9c2eb4d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee5f07e11ecf4032192f1af1d407ee43496d8ea579caf08353ef4e15e7c3011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ccc5d5caddae373d448d8620c9f8881d589c1ca3d187a2c313b02e546a3d842"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"

    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    # Remove optimization to allow bottles to be run on our minimum supported CPUs
    inreplace ".cargo/config.toml", /,\s*"-C",\s*"target-cpu=x86-64-v3"/, ""

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"

    # stdout is not supported, so install manually
    %w[bash zsh fish powershell].each do |shell|
      system bin/"aptos", "config", "generate-shell-completions", "--shell", shell, "--output-file", "aptos.#{shell}"
    end
    bash_completion.install "aptos.bash" => "aptos"
    zsh_completion.install "aptos.zsh" => "_aptos"
    fish_completion.install "aptos.fish"
    pwsh_completion.install "aptos.powershell" => "_aptos.ps1"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
