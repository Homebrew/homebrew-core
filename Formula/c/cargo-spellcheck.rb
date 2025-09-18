class CargoSpellcheck < Formula
  desc "Checks rust documentation for spelling and grammar mistakes"
  homepage "https://github.com/drahnr/cargo-spellcheck"
  url "https://github.com/drahnr/cargo-spellcheck/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "ab4027dea18ac252b1a3ad733f47899daa50dde3c90aa34f5f22534745f853d7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drahnr/cargo-spellcheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd89e47b7c68ffcb850bdb181127c956b8a3697e2a186fa534d471d6c420e64f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e4c34eabd5c01a01e81429472363789f826a4107fb087feb88f6350cc459e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "429f9b37061d3e2f7d69e85f8e2457642d32b621966ebd25b20717af067be0ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7be9cb9bf49c88cd65a94b13c136ec844ab8f7d00b57b7404d944199f12cde65"
    sha256 cellar: :any_skip_relocation, sonoma:        "7476f53530cadc1d65a76aab700faa7c547fae7b4230c7df8e4d6b90e99183ad"
    sha256 cellar: :any_skip_relocation, ventura:       "43e0cd41ac0873292789d23e3b913ff9b0dab96db3fd25d2df8c1ed8ea335735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc18490d34f7837b8498c833e5fa539fab2e0fec341eeb8e14d3d11fe15b8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf9c80c76e0eadf342f2dd4dde6e6c6f07c1a713fe2feb7e9c096a3877310d7"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "hunspell"

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib
    system "cargo", "install", *std_cargo_args
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
