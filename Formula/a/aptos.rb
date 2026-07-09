class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.4.0.tar.gz"
  sha256 "5f66ead457b4b1d0a18e6296d8afedc69f0e08c1b5711025fc302c8ade434063"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eb3dd2676f6ac260cb7c82115d0a70142185b5d5863cc73de82e7003b18d046"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877d2909808aa71b4344b7aeeec25151922325879956adb5798d31bb73d62554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9935c421434f43d66ba3b0a032873827100dea378665cc5363b75363e5666e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e59812d142ff77dc5f18ba333d637422231f40d3f2b7ecae377db53e5a62b3b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92cdb046169f4613ec701b062e64cbc7ebe66e7d99dc6c95bf0aa109f3d50996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a6b463102f66e5213614506b6e10ab14d488a889a28be0158a66534cfe1741"
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
