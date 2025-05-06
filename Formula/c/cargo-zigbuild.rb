class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "515fc1e815b21132fa82abfd5d9c8a0ee24fa18a1b63b454976a2cec2768836f"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11124f1b7bc4089f1918c1f68a8fb0c6b224ac7ccbd2938aab80c4455cb4ef46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "285a2f10af384726336effed66e13b5067e886ae028b3d81e1134ff8d7b5c2f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a344763915c8778a85d5499e99c7c76f235cb32ff7f4e2634198d48bb50d639"
    sha256 cellar: :any_skip_relocation, sonoma:        "473ecf36aca0dd4eedb0a72ef5119c29f695413ad06849c6ff9a5ddf03886429"
    sha256 cellar: :any_skip_relocation, ventura:       "0170524446d1a27fa6adcfba79a119fde3142e16ee858808d1b43262820e62cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78355307ef2f77e73215a2d72e945b06c36ab13f6fb4327c85d111f010ab06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "535ea9d8f507e5e53e33423ebc1d7ac351f630a119e47c5f8911bd0f4e2f4725"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
