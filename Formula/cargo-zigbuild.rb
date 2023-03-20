class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "ebfc5a2462626082d2c784e735c038a9e174abbe0b20b9d2cb185add125ee95a"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa5c322cc299fc50d02ceed6ebe65b5e4c80cc3993d4b3166c6a582dc690ad9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72f59cc23b8fa0cc350c13376799c078fbd23655d00ad5e4d6ef806182db3f4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e859b560c95be115a1c64d6cdb5b9dbe338807521499157a7d718972cdd13d6"
    sha256 cellar: :any_skip_relocation, ventura:        "3e7572302b04ace19a050561289467e9229daea54c28bde32f61ff35243af1c0"
    sha256 cellar: :any_skip_relocation, monterey:       "4d51c3fda648feb7d4b6a861c60d71450759ffe873452b33f97bd5a104748430"
    sha256 cellar: :any_skip_relocation, big_sur:        "4624f445cedf2dc76becb113c369ff46fe48d56d1fbe833e9fd13332499cf4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e5f97e9ef4b09a01b904d206971f0b888b19ddd262bba519cd4e0648f781595"
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
