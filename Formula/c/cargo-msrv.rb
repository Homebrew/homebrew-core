class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https://foresterre.github.io/cargo-msrv"
  url "https://github.com/foresterre/cargo-msrv/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "bd1108422a7dd76acba5bdd787a4bb36f4d97333b624aec3531f7d860dc2838a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/cargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5e15218c3a7a023eb8d5443d3a1b595fc4c0efdbbe63878179ebcd37be14767"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e4f620c6b60d312f7e1bb5b25036f0b77d78f493455712069f5cb6b388a281a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8205ee574e62ba13c2fc8239c0351ab6a6b1318782c31b152a63296a1b20fb5d"
    sha256 cellar: :any,                 arm64_linux:       "b0d4d923eb556191d228d767c837421f3d6fbd26a023347d1247bbdc2a2e12c5"
    sha256 cellar: :any,                 x86_64_linux:      "8ce672e4304f1877d2af8249bd0c4b25837c713f0f2919195c0633cc05071aa5"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/cargo-msrv --version")

    # Now proceed with creating your crate and calling cargo-msrv
    (testpath/"demo-crate/src").mkpath
    (testpath/"demo-crate/src/main.rs").write "fn main() {}"
    (testpath/"demo-crate/Cargo.toml").write <<~TOML
      [package]
      name = "demo-crate"
      version = "0.1.0"
      edition = "2021"
      rust-version = "1.78"
    TOML

    cd "demo-crate" do
      output = shell_output("#{bin}/cargo-msrv msrv show --output-format human --log-target stdout 2>&1")
      assert_match "name: \"demo-crate\"", output
    end
  end
end
