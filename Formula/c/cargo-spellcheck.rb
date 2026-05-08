class CargoSpellcheck < Formula
  desc "Checks rust documentation for spelling and grammar mistakes"
  homepage "https://github.com/drahnr/cargo-spellcheck"
  url "https://github.com/drahnr/cargo-spellcheck/archive/refs/tags/v0.15.7.tar.gz"
  sha256 "e1516cdf8fbd8596c96d15c19ab04349a69d03a249fd73287685ac30c08f764e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drahnr/cargo-spellcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b4b48e1616d2653f1bc5837848240d6c28fd222c517b967bf5f616f82335ac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22967040c3ba30ab1f6740051f181f4c819ef42c39772a557eb80a37d56da8a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c08d656cc0a62d8a97accf476166ed038a8ee9860bf5b945554557a0c6f32528"
    sha256 cellar: :any_skip_relocation, sonoma:        "98299dd56c020ec544f0d2b49d8c61e78b917d1a284d36cde8234f57a0913a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5574479c303340268ef548c032ca841ad475ff14d68b533e4c15d199700baa49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d14fe5a50a0274db17f76e0d6486e5d21e730dd8faadc7fb446ebcef54d902a3"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "hunspell"

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"cargo-spellcheck", shell_parameter_format: :clap,
                                                                 shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/cargo-spellcheck --version")

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      //! This is a simple libary with a deliberate misspelling.
      pub fn foo() {}
    RUST

    output = shell_output("#{bin}/cargo-spellcheck check #{testpath}")
    assert_match "libary", output
  end
end
