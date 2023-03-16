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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5abadf0dd313587ccfefc56e9221031fbff19af740097050df8119dc4561a701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8880994349d993c1bc43f8e16ffd306a7a694cb18b3a65f9b48b21b6edec727d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d111c571eec49f7828789cc6b69ad285b561814429938e681e283dee1567e173"
    sha256 cellar: :any_skip_relocation, ventura:        "130823733c4f665f6276a51cadc507b22b8525e331f4d5ef5a05c7c67f0893cd"
    sha256 cellar: :any_skip_relocation, monterey:       "65ca88c0ac76c713ae5d86435046ac8a93c8fa4c7678fc9e1d20fb9c5fb35aa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ef4e247f36584d5749bec3292947db3a9f9de05ce04febf5be5f5f24a1208a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d19e1033a01fe592e63a1469e3705a0e406c48f58e2c1a807fd0ddfc57d349"
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
