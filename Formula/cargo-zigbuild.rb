class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "f8dc30d6995e39bde81f15ba5bed1521508574ca5c9059b2ae71c4de6bb92aed"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eba41723ed4e99d83cd93bc7546693235ff4073e269eace2aec4e8862551b95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4104744022f1efa78bba65a050b1f3fd8d9680d10fcdbe5ce8b5b44daf238123"
    sha256 cellar: :any_skip_relocation, monterey:       "5099d06d5379ff5d8c46181937bc2f959314389825d71a57b140e4f3763bc75b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1761041224918316c2d92e7824610d9a8cbc0c14223342dcf5baaf4617ff6b6"
    sha256 cellar: :any_skip_relocation, catalina:       "047e2633e5643159d41484a1d40764e3bbedc12cac6b83cf9e4d0490288ecee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a3e0afb848c15b8cf825cfcf62124fc82061371a0c77e0492366132f6231f20"
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
