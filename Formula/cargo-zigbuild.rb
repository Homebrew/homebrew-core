class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "eb74f3ec6a0182f9b2851c37f0594413eb52a765e96397ce68b1f02fd0162450"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81214f841d7985109fa9c92177634f94a8e36ca01714d9ba27d4371bc8f412d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "914e2d54aa3f5b01e7ac85e4b1394ebbbbcdd8e45804bb2df90d55de8ace5013"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ded251fb8227bc61e55524d9a93f5b3adba8e3d3193d591447b264eb7ceb5889"
    sha256 cellar: :any_skip_relocation, ventura:        "e4f8e6f8317f299c36cb00a77d9910c293e572333bd2189bc1e8fa17bf834ef6"
    sha256 cellar: :any_skip_relocation, monterey:       "37b8623b2e58fc25104f93ea54a3be2923748e0f81de397aa577a918edf92a78"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a323af752c7fb7638a3ff62243cb42aeec0594513c738d3fab60e5f1984eefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54dc4d7b24bea2dd715193d59ff9295014e733da6965e00d94b3d26b23ca1caa"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Ignore rust installation path check
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    # Remove errant CPATH environment variable for `cargo zigbuild` test
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
