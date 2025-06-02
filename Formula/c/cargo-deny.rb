class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.18.2.tar.gz"
  sha256 "bb47741fada886c166e2a697a87fe93fca38ec083db489d404c73bcb0b9d7445"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58b03df4f5fdbaa5aadd5a840e112a920b444ef7ede092a95583d23867d5d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b42252981d9c034ed4f0aa004cb0e9a6ca83b0b03e8148312a5a201aa1172dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a87d18e34310a815fd7f12c5d39874eb8dc6a03d37af667c25448c6ba21fc482"
    sha256 cellar: :any_skip_relocation, sonoma:        "d55af9d3e6093b95525a237b4f76a70b230226af9acc5ecc5b4c5b973ad034fd"
    sha256 cellar: :any_skip_relocation, ventura:       "e4f6cc0ec3260e4f9a49bb5a395e1093df47c636c2afd7ad4bb36f41a8b2aeb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21df9e3645598ac9e4dd81e3ba0ea64f6a9ae816d33a839f428f2049234e7bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4360a2d46ba202c18da251705e8152ea52f752723d3f087fbe9cf7c0329994a3"
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
