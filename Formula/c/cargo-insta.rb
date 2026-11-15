class CargoInsta < Formula
  desc "Snapshot testing CLI for Rust"
  homepage "https://insta.rs"
  url "https://github.com/mitsuhiko/insta/archive/refs/tags/1.49.0.tar.gz"
  sha256 "4115f605a25f73bcf5bfda09b4992c03b6c37087f618b4afddcc43e23753b363"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66d453af9becd015f430d9a2a4e7b0834a51d05d56cce59bdc6028c092f7860d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bff749424745429b805d49f9ecee77368813f2927d86e4360590bba3dc79569a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8064ed44a425ca2fa958e2c06c303ca9237419329447a66220e1fefc8c21009f"
    sha256 cellar: :any,                 arm64_linux:       "945d27950d3dc8f1ff09be80c60c02932e95b8644fcb5b944d53fe696b9e47e7"
    sha256 cellar: :any,                 x86_64_linux:      "2a05782154dbbc0d5b6a77997697bb44773f9a21f73e70bbc46f6108769860e5"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-insta")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-insta --version")

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    # Switch the default toolchain to nightly
    system "rustup", "default", "nightly"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test-insta"
      version = "0.1.0"
      edition = "2024"
    TOML

    assert_match "done: no snapshots to review", shell_output("#{bin}/cargo-insta review")
  end
end
