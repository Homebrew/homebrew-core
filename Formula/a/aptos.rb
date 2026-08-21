class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.5.0.tar.gz"
  sha256 "d5120afaec91b84866ec982de0dca6535f4834a80d49d2909deb2623e0e46141"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5251759b6bcff6b4b675476155ee8f5bce24f40dd07c631cac6a963ce1a24f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e0e24a35b7a9f504c452fad7fa1e4999c2e2b4cc2d275c95206ba05598fd344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fb793630ea4ee115c4034c77c28f2a8efb02e7e8d2195f501897afd1f0e3808"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db0fce0fb7a2d1297932068abe06e01abf95374fdbdf29716c979edcef6450c"
    sha256 cellar: :any,                 arm64_linux:   "7b4a1b0296ebaa7b1ff4cd468ae617e6c2b1398cdbe87f9eced732ac020c1238"
    sha256 cellar: :any,                 x86_64_linux:  "ca6d95a71e4618604455784fffecd9ae61088df029d907466f2c272041f6f7ca"
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
