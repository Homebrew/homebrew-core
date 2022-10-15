class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "f8dc30d6995e39bde81f15ba5bed1521508574ca5c9059b2ae71c4de6bb92aed"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f13c0370e87c91713e8ce1af2a4dd89a0e61f53d661d3d2c6be288cf11ebb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e5efa80f7343fb6d156b3d2ce24a3d4a1d4713777c3c25768e990eda5b120f0"
    sha256 cellar: :any_skip_relocation, monterey:       "bc4ed858f78a4845eb077d680a4791d8ec367d94b0da5a11a0db0e9509c8da7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b1c96a73dbc8ed112e3387fc39f37d1b8fd1cf8fec60d3c08d2aaf62443fc0"
    sha256 cellar: :any_skip_relocation, catalina:       "9fefdf1e51f181807692da63d017fa21f527771da2fa4ad569516f9ed6de3281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82cd2e1a785a53c9551307ae9597ed1a866b6f867ca35d32cd6069d24a5407f7"
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
