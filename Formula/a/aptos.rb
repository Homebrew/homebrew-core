class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v3.1.0.tar.gz"
  sha256 "d5e17fab1be16d0c1a666ca705b15214cdf54af9d9075ea19a271feb311e0a37"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e03ff2d068203581154a76cd3c8b5125d311851ce3604fa2f9f1b421b4e621c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428b34d36d87e37441ea642ce31d692734bffb5d943ba63e612aabdb4d42dc21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "009b5db1d3f2056ccab0e3ab07505525cdcf62ceb934eed9517b2c929278fced"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a658be0e01087b694fd63852084ed0ed36cc5aff8413253a22b038da72e5bba"
    sha256 cellar: :any_skip_relocation, ventura:        "440a2ed42774cc36bb3c709914113a38d1a60bbdfd86755c65371a7acae7c75a"
    sha256 cellar: :any_skip_relocation, monterey:       "718346c4544066951c381af09fe492bccc6d34e37f33a330d666469f27f8785e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a3041f93f562d824f93cf8070163474436a0584098d19360fc888f5936a0a12"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
