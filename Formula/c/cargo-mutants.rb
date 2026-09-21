class CargoMutants < Formula
  desc "Inject bugs and see if your tests catch them"
  homepage "https://mutants.rs/"
  url "https://github.com/sourcefrog/cargo-mutants/archive/refs/tags/v27.1.0.tar.gz"
  sha256 "e57d8c31a8edee7d9265949aef896768729c824626897938e98a5d162a82bda0"
  license "MIT"
  head "https://github.com/sourcefrog/cargo-mutants.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "127c2957c81fbaf8e54d4cd5ce8ae8438d76939e929e0258e2c32526ef9c4f12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82dd60237c62d705eb5b3ece26d1df32384db2388724d9ca901f5736dff406bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab41e4212d8574327a5e869cfed4c57adb297a99e137896865dddb6ddda77201"
    sha256 cellar: :any,                 arm64_linux:       "68446138ea752a5729095db3c7c7c79821b721f371d7ec4132c89169469bfd7c"
    sha256 cellar: :any,                 x86_64_linux:      "fe47586f2a7b3deeab19226275dbffe7d52f74236c7f4e5bb8e54330d0e089da"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cargo-mutants", "mutants", "--completions",
                                         shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "cargo", "new", "test_mutants", "--lib"
    cd "test_mutants" do
      rm testpath/"test_mutants/src/lib.rs"
      (testpath/"test_mutants/src/lib.rs").write <<~RUST
        pub fn add(a: u32, b: u32) -> u32 {
          a + b
        }

        #[cfg(test)]
        mod tests {
          use super::*;

          #[test]
          fn test_add() {
            assert_eq!(add(2, 3), 5);
          }
        }
      RUST
      output = shell_output("#{bin}/cargo-mutants mutants --list --dir . 2>&1")
      assert_match "src/lib.rs", output
      assert_match(/replace .*add/, output)
      output = shell_output("#{bin}/cargo-mutants mutants --list-files --dir . 2>&1")
      assert_match "src/lib.rs", output
    end
  end
end
