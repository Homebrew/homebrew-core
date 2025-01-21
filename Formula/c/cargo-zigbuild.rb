class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "b445c5dcff98e327507114c6a6dbeda6fc738cacb53dbb4d1c713728985f6b2a"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8776090018d468b0def5035ce8deeec694a28fc06f355e66b98a7875a0bf3303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a242010d250c64fc5a6188b24b39a60f7b7b113425dd7e4032d9e1aa5f55cb17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23db9a4d425313abc1b7c5d1b5861d2032d50bd59c7b48d20fc1d2820e970026"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb781cf99c555f0cf82bc31b8ef9233f35b423d79f429e6e0a813d9ef1f4748c"
    sha256 cellar: :any_skip_relocation, ventura:       "54acf03df513b7f917949cf1dbf74d99fdb8a8312bfd4e635512244c4343b283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9da34109aa003935918b203b6c53bb73079a52700f2c75c513829ba2e6f3cb26"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
