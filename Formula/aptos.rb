class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.0.1.tar.gz"
  sha256 "86c7795d91ef90984cbdf249fc0616dfcae168c3a01a8edc6cefd82a9e0841ef"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d09a8ccb085572043f788d7f0cf181669f3a0cad0b2dc6080e1e3c0ae1142b96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c41b3d50de7fc831f54039fc8532b3accf66ca2bae4c0e0c8bc6b3fa1a5363c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75d33ad58d41f7be91ab888c677fa6d1512e41e5b990662a701f5fa29688ebfd"
    sha256 cellar: :any_skip_relocation, ventura:        "43d0faaec731167da5fff7d0d989ee5aaf9e5f3aee8053cd297aa6024694ba52"
    sha256 cellar: :any_skip_relocation, monterey:       "5f4003bf18f3dc6b8b4d5d79fb29555687bd5383d2e152424dccc9e9322216d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cef86772d8cba0656ff604bcbc172e9e9b8b4d693665fa9100dcd747c8261ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a913207a305f880f956086157428a23386085329f59d3518820c307c68056883"
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
