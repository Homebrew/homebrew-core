class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.73.tar.gz"
  sha256 "7222b8b142b1f8a703f728c57faa62723b94767609b94223b736dfb0a192bbf9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08f570a5f9be5ac6e1438f4644dd9a389806b3e085ed812f62e603821d19dfc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4358c4b2aeda9847b6c9e7d363616b6f296e973f84a1631948bbdc5ae28b5b03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5853f05d970b3e763e8edc305bffeeb648b1896fc88f46290fd1749c6da5062"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7faa6f2f7ddee3436e5dadf804a4e6bb9f445ef33e9749b466114c685728798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdc6e020bd6fafa627c01e14bcdbc36e08c7f3a17e62ff0601599655c968a307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddcedd44100687d036260c46c0ba1ce9cbcd2c8a78d58ec1f60f6ab13d7d371e"
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
