class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "9eb83bf6f1499a2c656a8cb0e8ff95c76470b1f24ae396bd880ed2e076db05b7"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "559cdf9839e96f0bbc3a1540af7d46a5e78c5b8629769a331a23d9a64fa58582"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a19ccace19fdd4522ee1567addc199fbe883560294605b2d57245f33e12800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec944facdd9d7b5625da191fb1dad3db7a5c4c65dbfdab0be37359c20d106200"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adea90aa720c0a9cf8065d6ca1476169b08fdbdc8a8ef150bf9a1783c37f4d77"
    sha256 cellar: :any_skip_relocation, sonoma:         "23d6760bf5270bc274c828f905e9f809249557a76f24384937949070b06d6de2"
    sha256 cellar: :any_skip_relocation, ventura:        "814ea08644c01ab533d7b6a273efc9fb2aa13119e79210366597b5efafc26dc9"
    sha256 cellar: :any_skip_relocation, monterey:       "e58fb49ee73a7e35556016152abfa4184aff9f6b29977dce0735571ea12230d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "263087830d9c960347a27b603f20f37a210ab2b024eba00e24d5032fe5e4100f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc6d019e8d40580737f3c3fe5beb15d83a58147ccac7df4b0a921595ec4e272"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Ignore rust installation path check
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    # Remove errant CPATH environment variable for `cargo zigbuild` test
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
