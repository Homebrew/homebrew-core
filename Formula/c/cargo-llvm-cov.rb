class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.9.1.crate"
  sha256 "5e00647cc92940c4dd82249c480fe08fd3809767e89f056bcec46d8a7962ea5b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34d59b6fa6b0c9e2d80cfe0c6c5ae6017f08a8ed12c98f3b71e8002348d5b0b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2521253ec79381fd88809d4dc26b9f751e9a70c5951d8febe0299737bc6ea0ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "752005eebeb25392bf6e53621df7a3b3bf21b2647fd729c91fc610f75dacef52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0bac32fa6e0864250eda5499e9ec8fbce831054163eb37a4fdf9d016e1e2d78a"
    sha256 cellar: :any,                 arm64_linux:       "4413b46a1588a616c27a03ce201943ab656548cc789cf10076cd8a1409fa9ff1"
    sha256 cellar: :any,                 x86_64_linux:      "4015f847321825d3f0c42bdd6ba830d54627a1b9c9644b306e00a7e97efcfc8a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_path_exists testpath/"hello_world/target/llvm-cov/html/index.html"
  end
end
