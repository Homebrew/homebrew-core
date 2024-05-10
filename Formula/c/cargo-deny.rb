class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.23.tar.gz"
  sha256 "e90a7554c2b76fdfb7b56f94f24cc1eef4bae576a7d458d87eb8c873db0d2ebf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74943806916b77ec52a733d5b3ef83574b361e6d897de031c46859f99fd8711a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ed64c4bbf660c007c4623c4cbbae8a71e3501d4426b6f1727412dfe2bfaaca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe545ac54cbb346ff45312a0c3c2ef4dd17b4e2eb2a63e64059d5a996ce472a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd124044cee4da66f36f4353293aa78bb863fbd3ce982c19b550e5732ec40ce5"
    sha256 cellar: :any_skip_relocation, ventura:        "3e6064f206ab4982ee4c19c384d6d752f8382b5a834782d93ccf92df8aef5d89"
    sha256 cellar: :any_skip_relocation, monterey:       "907d1734df34bd64c07a0bf66e61ebb7674c6cfaf90a25d2c6493e1890ae8cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217b2ab706d509ae9bb780e397ffc829d807aa8c39f0f1bd38148d893d432a0c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
