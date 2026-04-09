class CargoRunBin < Formula
  desc "Build, cache, and run binaries from Cargo.toml to avoid global installs"
  homepage "https://github.com/dustinblackman/cargo-run-bin"
  url "https://github.com/dustinblackman/cargo-run-bin/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "fd492430a60ca488ad8c356f9c6389426f3fbcd59658e5b721855e171cb62841"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b42c4020debdc5882322126e1a9cde14f8c78fd37de35ab7d9c51ecaf58e5f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7c12e5d94ffbe160210e9acfb61d1d01363fdf40650bd738a9529417aeb3e39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baace800a845a4478368f4f44438fb55be90b595850584b8ba0333c01774cec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18b37befe574ec3716f12943da256fb7b0c066dedacc9f45ec985a7c42bb3678"
    sha256 cellar: :any_skip_relocation, sonoma:        "52873150520a420f132bc02acf2a488597eb4957107a55da37633a26a7142d59"
    sha256 cellar: :any_skip_relocation, ventura:       "eae3e5a1faff8be5f6606211dc3fb2f38d6d0930f0dff73559667448d3decd36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d06798a0e079e6d97a0f56bac16c87271a2c42aaa5185febb28edf71376e6218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0cd8b3c3dac21a4430ac243db6f937aa3765efa7855dce3918cbd4f2421c13"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "cargo-run-bin #{version}", shell_output("#{bin}/cargo-bin -V").strip

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "homebrew_test"
      version = "0.1.0"
      edition = "2021"

      [[bin]]
      name = "homebrew_test"
      path = "src/main.rs"

      [package.metadata.bin]
      cargo-nextest = { version = "0.9.57", locked = true }
    TOML

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
          println!("Hello, world!");
      }
    RUST

    system "cargo", "build"
    system bin/"cargo-bin", "--install"
    system bin/"cargo-bin", "--sync-aliases"

    assert_match <<~TOML, File.read(testpath/".cargo/config.toml")
      [alias]
      nextest = ["bin", "cargo-nextest"]
    TOML

    assert_match "next-generation test runner", shell_output("cargo nextest --help")
  end
end
