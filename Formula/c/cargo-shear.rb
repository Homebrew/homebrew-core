class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "c4da6c4d6752741c0dff2b4404d10d4cef728125a332dd416c3147f57e8fee13"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58d39563d76c7c0a1e74918b5edbbfa406495dc4b4d53ac78d561b52bc249404"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56d50b4d3876c8561f15d49131c3667ca9e02a9b3e0786746a5fafe6fa08f087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86344dac8e24ab28411b6c7e1e832a21f8bb45fe172fcdd89e583a4a38ad808a"
    sha256 cellar: :any,                 arm64_linux:       "a2d026100073db03166bbde1c10696ba899d730de85283210c845cbfc96bbb7a"
    sha256 cellar: :any,                 x86_64_linux:      "f12468a1263f8b0cfe8c112594232bddc038a6a87c25caee7fad46a26d06467f"
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
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end
