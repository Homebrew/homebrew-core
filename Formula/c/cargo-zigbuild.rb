class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "91ba8a5018b4a9b46d4a2f03bada17d64f04dcd09869b32ac79adb3c85986ba6"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "025318c5cd584a1ffb38b88f9153abd27539fd3af8bdf024b94d259f71516dcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7dca479a8548775b8b813f8e0fa61f9b8661bcb3637aa7cadf0da645f5977d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43a1c1ba52fa46ffb64d51273a0954c7cfa4307a4a951bcff541621dffe3a21"
    sha256 cellar: :any_skip_relocation, sonoma:        "020e0879764a3d69b041aaca63103afbc753d3353042ba1c5bd2187f7d619ef6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c7c5e6273522970b17585078c6b8a25ca3eda870a1d50d422232d7ce0ca2691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a279320f184d7f2f66220e12a9a511899c766b627e660bfbb31bc1e8e869fb2"
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
