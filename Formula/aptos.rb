class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.3.tar.gz"
  sha256 "670bb6cb841cb8a65294878af9a4f03d4cba2a598ab4550061fed3a4b1fe4e98"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40434b61e99cf9114a3715851d01c09edaa94b814f89864d57a18d00a8e0c4e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edd6dcf9d627746a910d324422085eb4b06cdab654789a03b37133cd4868633c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9568107514168afc41e73bd3fd0fc45a6a9891a289857831f8ee027fb339676"
    sha256 cellar: :any_skip_relocation, ventura:        "d7289b5efca029aaa95328319ccf1d8a4813c7828f366314e569993eeeaf0003"
    sha256 cellar: :any_skip_relocation, monterey:       "ba58e1eb3398c725207ce9d6251d29b549cde32644c3d622cd286b86c7896576"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e2431a6316b8f0ffa4db75758fcdd9dea162fdfb3dbff56f5e405bcbea4fedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925113b4967ed9d3da78cd12745b1282198694a7f8c11d75b8c41451f8eff4b5"
  end

  depends_on "cmake" => :build
  depends_on "rustup-init" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init",
      "-qy", "--no-modify-path", "--default-toolchain", "1.64"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "./scripts/cli/build_cli_release.sh", "homebrew"
    bin.install "target/cli/aptos"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
