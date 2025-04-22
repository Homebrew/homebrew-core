class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.19.8.tar.gz"
  sha256 "a838ca39e3b4ee0e12b360af9a17f39365d3725200b43766dd983a6baf9ba117"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "411d88f0edd193b0c36f716f1dca39ab61bc2c97b58cfc734e6bd1d3c73761fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e07c00e05317a9781cdb3915a6f0deda35cccd6230ec555f1ca3a42a4bbf52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d767a707c22abd57cdd76d23bfa5e9e55f7f5f7f4785a3ac1324d5462408d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3eb7ab944d6e4c89a62ebe2c8e85897985672e1803e160b59f8c2ada308bbc4"
    sha256 cellar: :any_skip_relocation, ventura:       "80bab7f865eed60093dd1d7cf37f0e2008a1df446f306e85cb4512b3fa7ec252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a09b2e93db49b695fe93b6e351c7883f1be0705d99d70eb0facb5b11265c753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42451fe7f2b41adee9e90ef8753f490f81c9664523658c165a2216c6d1d3a5e7"
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
