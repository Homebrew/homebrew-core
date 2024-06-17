class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "842422e0255b5fc5f274deaebb66f82e6a9a61b1b936869fa3453dc6f817e10c"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eb5d769edd77dba56cac3df9ff869e88c55cdd746f3addac3cc5fb4f89a09ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "198a837a89d59a9bff4b7b2174f868edfc9a036b192b853b8b1433f4547df258"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbec8a424bbd1c6a3dc801836b1f10ca15a036c2cf88130d992e7380544e806b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3195431d5a4ffaabe17870ac3b99af9ed1161f72f6a827fbb74ca1a8a8f12806"
    sha256 cellar: :any_skip_relocation, ventura:        "98cafd75fa6a83e4ec96ee16506c2aa275a09d53da1d7d9c1027fbc4d1f694fa"
    sha256 cellar: :any_skip_relocation, monterey:       "4d87a9cd75936df38d50c6c22b36890273aef541282e97ce03267bda07591d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6145aca7525c8a162d789641e8e8506c8d72c540e8bbd7657d38fdc6e366e90c"
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
