class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "bdad52913b4b163777134e68be9b4ffeb010df459db00f4ddd071d223c891b85"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e06b73df01bf4ca21f2591baad1f153c224b5d421cb68f4dcc492c51d3647dda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ee4662fdd35ca2433ce6fb4825dedeea283f7bf8619e7e70676d88fb73a25e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56ab8720d4e5eed24498f15bd53add38a06f0b6c85f2d547a589b0a30e870a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b4fc3839eb6ac77b4307760856a5ee621e75edaa4c7239083d0bc09141702b85"
    sha256 cellar: :any,                 arm64_linux:       "a217ed16327b8078fa21c401c35b1c845b42d90ca71914c609237bc305c6be3b"
    sha256 cellar: :any,                 x86_64_linux:      "42e962fc0891821d3dc7e1ce09080bbbba9e72430773446d6787c44dbf81bf8f"
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

    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
