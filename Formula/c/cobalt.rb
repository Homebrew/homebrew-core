class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "0e3b8f23b23f0cd488399b0c13f08eadf9d7fca5bb52fef433fc075fbd050c39"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f3e66329a31b4bd2cfc2c4104c33fa18c8e3d29b8e31ec8bacddc433e9eeee3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "366acaee9d6f099ef35c78f4c343ed150462a46907c1b29e66f83d295c3b6ded"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bce9ba78d6061d536289c6fdb642642bea584f03cc011e475d4cf1f27b6049e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8421b9bc3aade05d10ea0744ca9cf2b4696ff85283a7e1b5eaeecccba431a74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "addedad1239ca5cf0bfc4d65199d26c33f980041407d0f1fb64c0fc63b06d91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e75ee3e155b750a00833882cef7a966a3d02feabeb8ab965fa8091af6e7b808"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_path_exists testpath/"_site/index.html"
  end
end
