class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "ffc07c1bb9f488bbf37344b438420813959112b7540ddd5f7d46cb809befe73c"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be6febaf259921de5931b1b75dd354b505ce38ddbfe19b4cb3da9f02dfbc6a6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ee9c3e852f0a50945da76297789eeefc2cbc36766c9f49cf5057ec8921beb11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "724dce69c3547c7b53dde909d245216520b8a62ed5fd1beed7de4c675340f808"
    sha256 cellar: :any_skip_relocation, ventura:        "cfda5726c96eebfc857e367ef0cec27b9810b3c6824fc482a12ec0be8e90534b"
    sha256 cellar: :any_skip_relocation, monterey:       "518dd9d4dfc1fb5216bd1e773c41615665c1d465bec9414d0e408aae44a79424"
    sha256 cellar: :any_skip_relocation, big_sur:        "c597d7b538407bf9f43cbb496e7402898b5e640fafb8f2b2c1bce37033b87a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de94e1a67ccbcfbb111e950e38ad07a2d183548b6d25b3f9b7b61c47a26c1871"
  end

  depends_on "rust" => [:build, :test]
  depends_on "rustup-init" => :test
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
