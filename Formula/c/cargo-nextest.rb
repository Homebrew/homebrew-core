class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.135.tar.gz"
  sha256 "b1c7f67c783c538a43a37743c60b3486f8707561d2acfe31a256317ba58b6831"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc211c840a0fb2bd01151768d41160cbe85c6c006a81d1e1dfa0f24dd156545d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92687007e1d06df53fd3098a32c46f1e802188ae6e167bfbeb04bd9f05f30796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a962b10109865e3559ac035785d6f74185bfe619f7d12c0fba07cde292a93c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0845284856d4d2b336dcb520ec532ecaa4d78594c4544775c31d135995ea9428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12a2e5a88f01a4c1a8e1909ae326b649e1b15ba0fe73d3db9f5bbfa086a05022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b430f9e83d24642e9b507e8ec9ff28efbf4b79067c9245b39cb00eeff1c75bd"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    features = "default-no-update"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-nextest", features:)
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
