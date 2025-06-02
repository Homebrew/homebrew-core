class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.71.tar.gz"
  sha256 "788efbe963f932eba64892841025e8c22ad3831ec4d7adfaab6817903da7706b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "637818a618e5efb0b8417b77e4e96c7d9123f54464cb9fe4c7e11199d2ba67f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3202657821902cf5a88ddfc5605d4d7ec3793fe5d794541d2d96a6b167b75124"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ad84d474218a8bef3060b73a016e3dd7167616f496bcc9c3b9072311c4d84bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfdbb72bf46604cd5f0f35bd8e6b7d5dcd67c14c6233eb186a62a18c1e35cbf4"
    sha256 cellar: :any_skip_relocation, ventura:       "10c7510f672ed91552e10e702ab9f67014470e3375076552804c2666fd827fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e57a158b14024ae12126747d3ccf13b000b1269a15c69d52e42d8280f00baba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3b2ee0048b5f03c09967054afd7be85182404094bea559326b4ea44aa8d5d0"
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
