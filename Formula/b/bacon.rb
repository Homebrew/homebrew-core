class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "d86249d01175f83ce30c7d52d36ed3422855c7eef00907161e673d490955702d"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "963ce13eb65a2065164431d1691506353bfbf04eb1a195b8bccab4e6f453e561"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57dfd236cbdbc2c01f0655d60303ad6caf566daa7751c2ad532939f083735d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2144195cd431d72695a7a4cb849ad75af48f3bb68459529a37432501148f1bee"
    sha256 cellar: :any,                 arm64_linux:       "feca94f0e0323578563f0da2177a8fe2a00efa8faf43d7b3c98e776410617357"
    sha256 cellar: :any,                 x86_64_linux:      "2628e7932c928e74e67008ff2b021525fc70fb754de112c25aa9c9e11e3612ef"
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
    generate_completions_from_executable(bin/"bacon", shell_parameter_format: :clap)
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
        license = "MIT"
      TOML

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
