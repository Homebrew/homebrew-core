class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.1.0.tar.gz"
  sha256 "940db44e50d90386af61ba00495dc7329f6aafa3f5168473c65472c85a3e3c1b"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f63609819066da6a3a2f11e464513c13192cfa61fdd3014cea5ab7a843a253f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3d1c00c39535a964b4c5aad6170aec3cf6af87ee26d13fb67e3841f7c659960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11112cd13554fc2c7ab5719e977832a863bb076e33505ffc69c255d4b560dbe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5807bb15bab96ecfa699f87908e7deb89c70612f9cf8950a390e51c93a570fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35e6ac7edee51c1f2f20da23357d66c539cb3cce43180b1280a9d041fce819d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80949a756ad0025b5123dc7001975ac4cd500a116809b4b367e72f7d48ab7cde"
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
