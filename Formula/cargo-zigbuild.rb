class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.7.tar.gz"
  sha256 "c9c2291b6b47742722288d4d7a24ed6d572a66463df0c946a02fecec67adb144"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "263b8fada5eff514c6f1f9b1aeff32398c8f96c3ed8f5df9b3a066a1697d471f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10b9c709b0385a9cd0fe868b30e58f1f6d930555ed63adc68fd099d23a37bda4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f228d6f324a1ceb6106f0378c92192c956bcf4d4b90a7efaae6e2b9a6d7a2649"
    sha256 cellar: :any_skip_relocation, ventura:        "b326afe209aed64d399204fb3813eea216e975625f0dd065e9e2794f784824ee"
    sha256 cellar: :any_skip_relocation, monterey:       "d5852e1d5e00dee6dc47bc35521af7b740b897a89bdb79b3d92f96969e6d738c"
    sha256 cellar: :any_skip_relocation, big_sur:        "79abd3ac9b122dcc93d7085e3bce5f817d047710cc10b5ba50f65a44a67a0694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c0e4cc0c1948a829c1b5d06e2045ea9ca41ed65d28bc46debd232f609a68236"
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
