class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "c0f88917dd694d0d29867585d7c57af4428a889a3385270e3e0767f09ce3c80f"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e643dbc6a8066e18d60d47748b07ae9ce40fe07347f71ff126da73680e426711"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "913d764959b46d5a3b3423996c4986e651729934c079d40b0301504eb959f102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b91aa753b39f5c4575e1b017438af2294c1f95f7ab6c7435f9986fed73e617c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce0ac3a2dfdeefec174198a9c4c505a8356d989c8f42f9d3d0597107e48412d"
    sha256 cellar: :any,                 arm64_linux:   "aeec4c0f13e3cee955b3478ecb4373566260ace7460f6a0b27acce8f614f9028"
    sha256 cellar: :any,                 x86_64_linux:  "3b62845e501d4f70d167e55dfaa379e23a5584fa32fcb594f99622c5115d1bb9"
  end

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
