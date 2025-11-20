class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.5.tar.gz"
  sha256 "d04cb7b0b9f75c483dc37d72970a8c759674d1a7b882aaae2c56a60fe18361ab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2ed484f08e2e6e3d93bc254f594ba0d7f1c88f6dc130bc4e2b3cabc6645c6c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61bb9e6d331c959bd86cdb52705de6d7fb156263c2a61ca6450c7dbe4d454295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1e3b675a931ce1082f02858cc9135e1a3f2d404725f54e2c0f554fc311a5129"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5761a9c2b5d7801012768c43ca4e92aa9708400f93689d4121e6ac6130a6a35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dc21fd604fb064961dd751a4fd90f913e1198a65625525faf2dfd2c126a73b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a9c2581c24de7fb54c4fe42d731a08c77b0d77e4121d83d5cbbb6377b1052e"
  end

  depends_on "pkgconf" => :build
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

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
