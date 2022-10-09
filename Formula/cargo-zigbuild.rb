class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "ac06a0a95347c47598ebb470e717ac7b143f90e4061c7ec2bfd8c15a2024c68c"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "598353c177514edc970c5272e16effc2c73225ff3e0581ac36adf8566059e738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c065ded6be0f7d3993d59c595aafef5a65f102429ee6f62aa3408872009e2bb5"
    sha256 cellar: :any_skip_relocation, monterey:       "bd86bffe0291555dc4645334a2754fe6a2a61a37d54dcca1fb4faf4e0dd1ac8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e26fcb8bc8939477a78b7f63ef5a6138e17ebf6249e76e592f204e3f48ec3c1"
    sha256 cellar: :any_skip_relocation, catalina:       "c80fdebc14fce04c794adba18707c250a351dc1b7e23cb6cc9a4b89e586ed2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32ea74fa836c7265bb7d14c837a32edef24c211cfc29426ba1ccebe0554e672e"
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
