class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "ffc07c1bb9f488bbf37344b438420813959112b7540ddd5f7d46cb809befe73c"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d910346e220d1f90693111965aa0acb882e6c50749c532f3e3e020f3131c71e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63997e3afad6da3c71e6bb2831d784335f7327d1ba06e34dffcefcf1fa9725d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e89de0789bb39a7a389163dc238c6067a9524ec258cc4726cfe6dbea1137bd46"
    sha256 cellar: :any_skip_relocation, ventura:        "a19cf56becf69a62bfe4f9175f23d2c003db4324916a9edf01dfffda1df05e69"
    sha256 cellar: :any_skip_relocation, monterey:       "4e9ce5262d4a2bca58564b7ac89bd23f0cb7738519a8919bf8d213a3a9c9fabc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0821b0c3da436d5e1e857f81b5f3822e92e7530d422261da81e426ee2ee074ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "175f33a983eabffc95954b97187cc28403c86d59924af49a89b2b48b83d2094c"
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
