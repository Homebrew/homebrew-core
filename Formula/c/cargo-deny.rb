class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.22.1.tar.gz"
  sha256 "d7f5ed86cca7f85b16db245c06841c1977218bf3570199aae0f6dcf4b3b7e6db"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    manifest_sha256 "140770974216ece43b32171520ce5300ba8f8f3f971f497f4546c47223d4b200"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6ff0501b708bf6eb1b11037b1f25f0b4d92de5817e1e550716f904fb1a308f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b8727da521cb1727ab1a8a821ab386f309c2c7f0189dd103efa391860f12922"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d26f998b5ca737266f71f17975df9e0dabb3b317b8da547c02c8379f41a4fa86"
    sha256 cellar: :any,                 arm64_linux:       "e7ba9dc54339664a1d9dc8428b32e73088bd77a40e084f0565023dc2dc4f0167"
    sha256 cellar: :any,                 x86_64_linux:      "eb7896a99b014be2ab7a4fbec1081a17f89ea5ac5862b7014cd7580500181580"
  end

  depends_on "pkgconf" => :build
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
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
