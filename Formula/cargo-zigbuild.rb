class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "8d3da6b0d4ee944c9171e56758306e47d07c0ece8fbfc5c94206e292a6ae10a2"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dfe63e7ab11618fe23adc21c14a709237ff3894af47e8bd84ecdba210fb9683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9fa1eb080cc774bbba9c24831c087ce290302c177a5cf01a5b20811d5d8f40b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8195da336cf2d12a69b6918a5eaa9a331247d74d8d8043376816da8d1eb1c7d"
    sha256 cellar: :any_skip_relocation, ventura:        "32ff08eb0137d278813ad08ee3bc43e46a22b0175139c63a90f418b00a6784fa"
    sha256 cellar: :any_skip_relocation, monterey:       "85966f597b56b56bdc28677e759cd85c790e051af63b3738687bc2dd13a52ae8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ad75dc0e1dd58f0c0e1bc4f29b63e8392fadf0d53ad4edd7ed54755923696d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff30ed1f7ae1ae154273459d9baf55b36d2d1cbc4cb98a5ab2faefdcd1b9747a"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end
