class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.77.tar.gz"
  sha256 "829376cedccde0d6dcf242ca22234d8996e64f51c8033cc1dae4819e6b0a27fb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f400486921d7811a7f7ed596f4c33f2e51a797db2b52b903c15211c486758929"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b151f3820b3562bf74f3b8d4c5381a13ea6ffe9bc5ef05e77a1987796fca8d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a29dd366672322264ff1884de9fabf7df48eca9df50227770918679152eea598"
    sha256 cellar: :any_skip_relocation, sonoma:        "3574138c5cac8113bc4dead416e3b9f471a8740e441c1123628351bf811ccb84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c21df49229ce0e38ca968e3cca0b6bb2349d8950f04780921b98ae34d03efb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d593128abef69e447abb4ab5f901af850539f9a585fb5709d1631dc24ae1d8d5"
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
