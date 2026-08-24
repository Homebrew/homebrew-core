class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.78.tar.gz"
  sha256 "994607ada64cd0f03881996d4d07b93077ac181a7751599748ac6a0af703d869"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a9f15275a1f0e042bb2e6681a3ae78e4f82df0bd87bfaba50fae02505a10a69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f844df2f951eb772b31353861d85ded4c7fc93d04af14b52db27eaf2356d2044"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5262f266937c870fbe412960f1b53c4c6826fe1da5ae1c72a78dd260a24d84e"
    sha256 cellar: :any_skip_relocation, sonoma:        "53f3aed8ac4a258b4f1cb89118b33b9161ac409a08244b21c09b3f647138c244"
    sha256 cellar: :any,                 arm64_linux:   "470374f1395537c5748ffba44d295f897e923cbf7f1964f30a1148e710598f85"
    sha256 cellar: :any,                 x86_64_linux:  "b3329ed53ed3b59706bf4555109e1a04573871520241507867bb3ef9234f7ffe"
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
