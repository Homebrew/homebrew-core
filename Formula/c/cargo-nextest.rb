class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.95.tar.gz"
  sha256 "cfe167f9d71e54cd6eb3e9bb20791b8c28831dfeaf741ac3a08afdfbe3e09b08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd0db3353ba9abb7942181f70c2ccd8cbb5fdaf6570cab563d727183e0b5d19b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e77794bb84549a156e90293936bb2f76fbfbd1c546814f99b95630fb070e53c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a8f3c8e0e28358ca8b939cd9fd59dcfaeabd6bc564d3d38d2b4af964ac6b361"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dfee8b7e8ce5e1fc4ada8881be149ba3c017513015d3d6e0d1850c2dd159a31"
    sha256 cellar: :any_skip_relocation, ventura:       "027c471d36aba17e62d99bfe703ab8af2ba08c2ca5d66544d48bc4c73d345097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20513c28017f4ce346d4ca1d3ff9bd7a7534a442da14b7ee2672ad8ae6b55f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae466953041dff36c362b60c500cb3dc930bbb20379461e1fbe42641e588593d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end
