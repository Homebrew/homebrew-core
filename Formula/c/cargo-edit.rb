class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.14.tar.gz"
  sha256 "52f49ea8f76e2caa48d3b57bbcdfe1768268f25ad9a1f07878d9c670488180fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2776af02dad88ffdfc01d61aeaca4d496f9bb58c995d09962cc96b000ca38eba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2829c244c2935030a4f310cc1625799dd927da1b740830dc6de1c2afbc3586c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91f910fd9a106e1f395f2aba438636349fc5ffa3c4f976e864bb2bd31ac01813"
    sha256 cellar: :any,                 arm64_linux:       "1a256130dad7611bb8ee371a59140f883dd22845f7775e7c1c358da40b9f001b"
    sha256 cellar: :any,                 x86_64_linux:      "61a53b4146a857b371d9f8b628cf67fc927565d4769b52a1ceb539980c3d9d14"
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
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      TOML

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match("clap", (crate/"Cargo.toml").read)
    end
  end
end
