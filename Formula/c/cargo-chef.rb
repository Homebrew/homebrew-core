class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.70.tar.gz"
  sha256 "ee536ae950d06876cd2f990265fee0b988bef327aefaad7810e78326bf922a7a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1588e13a8040165d4ef940ce48c843336164e3e25def1579086c064e48d71136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bf8e2b5b75b6194e6a267391ee5f65bfa7cc12ba279b220b7bf0d690955d375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3febfc109b751c6dbe45b8de79893565734aa5d8b6df23f2ab019284c5c1f0f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5812b8acabf4c91e6d70ef51261bf2cdf03bfc079a8b8d25457d69089a7abb48"
    sha256 cellar: :any_skip_relocation, ventura:       "483f7dadaf56f6361e2ceb24f60d9d614e706a4d4da0126df4df17fdc0c64225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76302bc1c4a78553764cba09ab5f415f2fb4a9ab1f8261f4e42af48f83f91c2"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
