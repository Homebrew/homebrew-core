class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.72.tar.gz"
  sha256 "62ab1457826bd5d48fd89a505519f499c3a2283c456def1000d460c99bf9f9c7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "283f2980404e5ef4f6885dd5d8771b1b8f1a65613db76a4816914b631758218e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cfa16736299cb85096d854c7251296f29ee5cad31b02ebc503ae749722efd07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42b2f63b0c6612d9ca4b94a9b72669fb7b5fb096427c6461513835fd4ba299ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe6de35e8db504790c4c970111343c338f88bee112e8d2340f2f5a16c3cb822"
    sha256 cellar: :any_skip_relocation, ventura:       "2bcd0307b471b47b0b687ccc4b8fa13a0bac6adb3452db924ed9feba84d8696b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "802d7e4ce54963699b4df6ae31a0eaf9fe0b8c148893ab0ae82257ea16d10270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86cd965d1004e0b09fe88a191d2e98d4e265a86dfaf41fcbc42c95ea87f2b279"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello BrewTestBot!");
      }
    RUST

    recipe_file = testpath/"recipe.json"
    system bin/"cargo-chef", "chef", "prepare", "--recipe-path", recipe_file
    assert_equal "Cargo.toml", JSON.parse(recipe_file.read)["skeleton"]["manifests"].first["relative_path"]

    assert_match "cargo-chef #{version}", shell_output("#{bin}/cargo-chef --version")
  end
end
