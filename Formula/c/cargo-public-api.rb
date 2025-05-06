class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https://github.com/cargo-public-api/cargo-public-api"
  url "https://github.com/cargo-public-api/cargo-public-api/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "4557a2d1017e2cb83cb9afc65654fd9d4602a8e92abfaa6f99a1f40ff80c00aa"
  license "MIT"
  head "https://github.com/cargo-public-api/cargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f894595937a3cf35b508d3d023a9bdca1bba15f0ec3f454544a3632b7d7748b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3847e7ea0cfa8c6b9196c9d482119ceacbe3f2be395a3aa2959f6c4eba512d8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5d75ef2bf46ae33f55a11547019adb1fa58bfd471937df4e4d795181cf6a708"
    sha256 cellar: :any_skip_relocation, sonoma:        "93833eb1c063d0c8d84ccdd7719203d41db707b7f582ba3d067b567cfae17a11"
    sha256 cellar: :any_skip_relocation, ventura:       "a9c8c826519f8fe57e22787c8c74ac26bd1ed806a3d464ef42196ade2965bade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd8187f8fcac703d34d602757c3fadc5efeaa469e9fd8457d862f8391f66e2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f3705d706ea068f436c3839daf51fdbd3fa8645c6850b95e69cb7cb84dc650b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-public-api")

    generate_completions_from_executable(bin/"cargo-public-api", "completions")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_package"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      pub fn public_function() -> i32 {
        42
      }
    RUST

    output = shell_output("#{bin}/cargo-public-api diff")
    assert_match "Added items to the public API", output

    assert_match version.to_s, shell_output("#{bin}/cargo-public-api --version")
  end
end
