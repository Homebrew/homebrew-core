class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.8.tar.gz"
  sha256 "3cd5d16c84277b444600ac83f1387ec1c6fab95008b642dcada3a135a08798f1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1114ad4ef7342749402cbff2bee0fa83ee8716632d55a6d4b7d93f0e02d98820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "018bb0319f1cf7418a3873ad0b34bacaf7085b95d2681bcec224c63d0ce1366d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dc10dc8882d695ae799d8778cf776f85b76cf059650ad6db3e75d2eb945667e"
    sha256 cellar: :any_skip_relocation, ventura:        "50e8af508400a69f440e89a15628e0bbcf29e70bda877f9f894cfd56ab71c02f"
    sha256 cellar: :any_skip_relocation, monterey:       "e0e7e0a9190872e7a02ae1d20e4aa2b5a3720b677851122929c588f857939526"
    sha256 cellar: :any_skip_relocation, big_sur:        "035f80e395be83e386b7e64e00887602d90d0098e20ba0d1627a508441432ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1b92af3d6b8715aa2759bb8004e1bb823c5314f17eecb20f3bec2dc4a9db0d"
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
