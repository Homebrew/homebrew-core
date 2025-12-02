class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "0efcc28c320c14798859a85e15c9892372092d661a9e4d0cd03010d7ae761270"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0295adfc97e5e49159b7da84c2c8f844669a1dc02035a01ffab1c1f577fd14fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "139cca9e9f79e8f13d0e87fee0199442e42d3b1328c3d4c282795243f316f090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98f28208325ead1b7770ac0465a6f3010860142799a43b8ba276a1a58f73afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dc980ee43eff560c42878c0c1d47f6f165f667aea6ab2d7db743b5b96917e76"
    sha256 cellar: :any_skip_relocation, sonoma:        "87fc281f86cdc74f2725c2882759138055f158fb630893d281aecb0f7cab6311"
    sha256 cellar: :any_skip_relocation, ventura:       "1914d6e520ce2bbd687217cc655ae36aaec646429362a52973c0b0ae9d9f673a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fc410efe6c247a06e3136b2def0effccf52340633cdb04d61fb8f2ec32219be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72e6d2ba004e31387a451a01982dbd3cc2399b660b56a4926281357432f2073"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
