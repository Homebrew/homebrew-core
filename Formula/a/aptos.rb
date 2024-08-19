class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v4.0.0.tar.gz"
  sha256 "f92824beecfbe17a4255452c58922418edad314fcc89ac00abfa956fa0508c55"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17b9e5f59ba7ac1a9053c9c04006a47aeaef692d7afd5ba18f78238a28063da7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4e855b47c44fca348f8d96b9e87b5847c3bf54f0d2b1f8274f7cb2f8f71da54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5f04601345109165fe47b04437dd947df052552641dae6645dff2360c4de58e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4b205de8e54c342b9292d4c4923284542a66aa4a4106560d39e961835985532"
    sha256 cellar: :any_skip_relocation, ventura:        "3cb4654d52799572c4539d6569e3f3240833b4c65eb4837ba616642b16c0300a"
    sha256 cellar: :any_skip_relocation, monterey:       "9e3d572c089f831f86d2b04e83cbb3c5c9ac1848054a0d8b05c6cc6f72676a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29ed18d624105d378c20d579fac89030c39b523d33e288e98392c4a9a8407a9"
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

  # rust 1.80.0 build patch, upstream pr ref, https://github.com/aptos-labs/aptos-core/pull/14272
  patch do
    url "https://github.com/aptos-labs/aptos-core/commit/15ec18e4a2533fc9f3e8d23f5629939a07490c23.patch?full_index=1"
    sha256 "92384b60959e5c9400542e3215445dc3ae634693e41de9ae8b1907ad7557c5b7"
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
