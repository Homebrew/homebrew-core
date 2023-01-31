class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "a6f855a011062cb19c7e921aeeac1188edca9ae7ac0c845bc1346921ea982feb"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c390c993076d78cae3b4dfc68d8c8e3ad638d2b3302d147d147fe2d1ae10d29e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d000c67753f556293f0a8b30c45259ef23eca482d88accf2736a0955edd5e4ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d6e0af087e44569e9c17527acc6eafaaf33da692b42b6f04e0612c01c2e1cd6"
    sha256 cellar: :any_skip_relocation, ventura:        "64bb5ebb4ae04849c6514d90825b6d92d04c51102c0684bd0fdbdc2e2e05813d"
    sha256 cellar: :any_skip_relocation, monterey:       "ed8293c2222a42b4618be39f342afbfe0ce22802fe90958d754a4a28f6340536"
    sha256 cellar: :any_skip_relocation, big_sur:        "f90f71077969787e2729c58bac6234cc8180241a15ae327b6daa29adf49140d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05164bb0ef3160328a0f396f638a3f3115e103355f82df7c968c06ec813c5352"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
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
