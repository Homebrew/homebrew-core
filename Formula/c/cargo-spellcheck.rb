class CargoSpellcheck < Formula
  desc "Checks rust documentation for spelling and grammar mistakes"
  homepage "https://github.com/drahnr/cargo-spellcheck"
  url "https://github.com/drahnr/cargo-spellcheck/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "ab4027dea18ac252b1a3ad733f47899daa50dde3c90aa34f5f22534745f853d7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drahnr/cargo-spellcheck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "326e88bcdb1597ccb4a04b1da254081c5af47c65f3fdb0c506e35adf3dc56e24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fab5b1581a397e0776c84e933b94097d8a96fd61f548e376321c892abfa2aa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7be9eabcfbb07a45dced0dd3356d26ef6b7b31a422ee2356222cf23327604228"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ef273e407c69f213ca9637e6e04b5c89d55715d27bbe71c361e541caeea8b2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "428cf7e2f5215ad664810553cc83adfc474beceb7a03d08ae671f8ab7a88fe52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666cde4c0816a27802d38b2700ab4d815811645737b82d3769a2b13b2ac9f9d6"
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
