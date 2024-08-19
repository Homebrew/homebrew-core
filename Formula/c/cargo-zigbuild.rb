class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "335f441157560d8cf9bc3f5ea4e6b5dd29da8aaa70b7504c1b904442840bb55f"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14e2c410e2abcc14e216745f8ce16f3932c7dfe6c77b1b44840bbe8f563954ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b66ce12ac72d3659d3f38b5e1d50b6ed72dfccbeb27fb34c97e8fbe8122a9c5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cf4e792ed4c3a23e1cd54fea677ddee8003c75b6efab0eddb7329dbf8134e56"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1bfdccd009f46fa7023ac253ca96da50e3592a5804e37867ff69581d0091d42"
    sha256 cellar: :any_skip_relocation, ventura:        "fa613fb487a8c34af7cd6710a096dd5874cebc794b2e98d6f48bde157d88e0b3"
    sha256 cellar: :any_skip_relocation, monterey:       "3a1ed2e7e356a00a155ec1416e8fbf84a76f036bf1243a0ee3883ad558646aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13a781ca29b03c00b5c204dfa7b7887d53ff3741a19dd6a8274e18092d40ad53"
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
