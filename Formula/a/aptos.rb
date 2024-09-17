class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v4.2.0.tar.gz"
  sha256 "052f5562aebd9dac5eb198ee421be7bbc4698e943cf3d5ff702997c8f500a9fd"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1663ada72696fe3690ceb71b7f2a5a6067fd6ead66622ff983c6392b2e88cbc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "036d29de435b5607e38cb884869a1d7245c166851083e43150e4b4a4eba16f52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e75cb2bb62b203547c051edde37aa1103453bf0048c43c2d474b50121a8d41d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fabc3d55657d5367746a1f573f0f3324d4d2615ec048ec80fd335863de3f15f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "750fc470c98e9e7694df65f67213bd6f6dc28ad6153d007eb24ea50538ae6e30"
    sha256 cellar: :any_skip_relocation, ventura:        "7eb805275ada1fa107072550978e805caf3d5db59d5936820c3148fe62b0d568"
    sha256 cellar: :any_skip_relocation, monterey:       "c16ce77e36fc6ac23b7eed0aaccc636a6b762a392a95b31819bd621b98e055f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1225382cba7102e757d537162c6b878fa69a0cfc51e6797bfd6fe82ab69d719"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
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
